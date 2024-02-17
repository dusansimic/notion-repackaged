BASEDIR="${PWD}/.."
WORKDIR="${BASEDIR}/work"
SRCDIR="${WORKDIR}/src"
PKGDIR="${WORKDIR}/pkg"

for DIR in $BASEDIR $WORKDIR $SRCDIR $PKGDIR
do
  install -d $DIR
done
