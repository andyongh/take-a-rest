# SPDX-License-Identifier: CC-BY-NC-SA-4.0
# Version: 2023-11-15
#
# This make-snippet will both check for the utils you define AND
#   automatically create an uppercase variable with the util name
#   for you to use in the rest of your Makefile(s).
#
# Usage:
# ======
# The utils to be used should be put inside the UTILS var, separated by space.
# Example:
#   UTILS	:=
#   UTILS	+= setfacl
#   UTILS	+= chown
#   UTILS	+= chmod
#   # UTILS	+= nonexisting
#   include CheckUtils.mk
#
# Explanation of workings:
# ========================
# Lines #52-53, #88, #90:
#   For use in recursive make's.
#   Makes sure that the code inside this make-snippet is only applied ONCE.
# Line #54:
#   Feedback header
# Lines #56-62:
#   Creates a macro for uppercase conversion.
#   It auto-selects from two versions, which you can extend as needed.
#   The first, bash variant, uses ${VAR^^}.
#   The last, non-bash variant eg sh, uses sed.
# Lines #66, #76:
#   Is to prevent checking and defining the SHELL itself, but allow it to be
#     displayed in the feedback. 😉
#     (The shell is included as first util to check in line #65)
# Lines #68-73:
#   Is to let make auto-create the respective variable(s) in uppercase with
#     the found executable as value.
#   The export in line #69 makes the created variable(s) available in recursive
#     make's without re-processing.
# Line #74 in combo with #67/#75:
#   Aborts the make with an error if the requested util can not be found.
# Lines #77-84:
#   Provide feedback about which util was found and where.
#   The output is nicely right-aligned when the length of the util-name is <=20
#     (Line #80)
# Lines #86-87:
#   Feedback footer
#
# Cross-posted-at:
#   https://stackoverflow.com/a/77223358/22510042

# For recorsive invocations.
ifndef CheckUtils
$(info ### START: Utils check)

# Define macro w.r.t. shell in use.
ifeq (bash,$(findstring bash,$(SHELL)))
toUpper	= $(shell string="$(strip $1)"; printf "%s" $${string^^})
else
# Insipred by: https://stackoverflow.com/a/37660916/22510042
toUpper = $(shell echo "$(strip $1)" | sed 's/.*/\U&/')
endif

# Inspired by: https://stackoverflow.com/a/37197276/22510042
$(foreach util,shell $(UTILS),\
  $(if $(filter-out shell,$(util)),\
    $(if $(shell command -v $(util) 2>/dev/null),\
      $(eval $(strip \
	export \
	$(call toUpper,$(util) )\
	:=\
	$(shell command -v $(util) 2>/dev/null)\
      ))\
      ,$(error No '$(util)' in PATH)\
    )\
  )\
  $(info \
    $(shell \
      printf "%*s = '%s'" \
	20 \
	"$(call toUpper,$(util))" \
	"$($(call toUpper,$(util)))"\
    )\
  )\
)
$(info ### END: Utils check)
$(info ) # Empty line
export CheckUtils:=1	# Mark already applied for recorsive invocations.
# $(error END: Utils check, forced for debuging this snippet)
endif