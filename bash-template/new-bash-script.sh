#!/bin/bash
FUNCTIONFILES="/opt/bag-of-bash/bash-template/function-files.list"
SCRIPTFOOTER="/opt/bag-of-bash/bash-template/bash.footer"

SCRIPT="${1}"

if [ -z "${1}" ]; then
	read -p "Enter new script name:" SCRIPT
fi

if [ ! -f "${SCRIPT}" ]; then
	echo "INFO: Creating ${SCRIPT}" 1>&2
	cat > "${SCRIPT}" <<HERE
#!/bin/bash
# PURPOSE:
# DEPENDENCIES:
# DELIVERABLES:

#====Begin function sourcing==========================================
$(if [ -f "${FUNCTIONFILES:-/dev/null/null}" ]; then
	cat "${FUNCTIONFILES}" | while read FLINE; do
		echo "#. ${FLINE}"
	done
else
	echo "#"
fi)
#====End function sourcing============================================

#====Begin Configuration variables====================================
# Note: The values may be changed by command line args below.
#
#====End configuration variables======================================

#====Begin internal function definitions==============================
function Usage () {
cat <<EOF
USAGE:  ./\${0##*/}

        -h           Print this helpful message

EOF
}
#====End internal function definitions================================

# To add options: add the character to getopts and add the option to the case statement.
# Options with an argument must have a : following them in getopts.  The value is stored in OPTARG
# The lone : at the start of the getopts suppresses verbose error messages from getopts.

#====Begin command line argument parsing==============================
# ---Test variables set by arguments in unlocked tests---
while getopts ":h" Option; do
	case \${Option} in

		# Options are terminated with ;;

		h )	Usage 1>&2
			exit 0;;

		# This * ) option must remain last.  Any options past this will be ignored.
		* )	echo "ERROR: Unexpected argument: \${OPTARG}" 1>&2
			Usage 1>&2
			exit 1;;

	esac
done
#====End command line argument parsing================================

#====Begin unlocked tests (exit here will not leave script locked)====
#
#====End unlocked tests===============================================

#~~~~Lock automated script---REQUIRED for crontabs~~~~
# Latest version: https://github.com/secure411dotorg/process-locking.git
#HASHARGS4LOCK="true" #prevent same script with the same args from running concurrently
#HASHARGS4LOCK="false" #prevent running concurrently without regard for args
#. /opt/process-locking/process-locking-header.sh

#====Begin locked tests===============================================
#
#====End locked tests and begin execution=============================


$(if [ -f "${SCRIPTFOOTER:-/dev/null/null}" ]; then
	cat "${SCRIPTFOOTER}"
	echo
fi)

#~~~~Unlock automated script---REQUIRED for crontabs~~~~
#. /opt/process-locking/process-locking-footer.sh
HERE
	chmod +x "${SCRIPT}"
else
	echo "ERROR: ${SCRIPT} already exists." 1>&2
fi
