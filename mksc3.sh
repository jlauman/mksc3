#/usr/bin/env bash
set -e

if [ "$#" -ne 1 ]; then
    echo "$0: project name argument required"
    exit 1
fi

NAME=$1

    
mkdir -p "${NAME}/"
cat << EOF > "${NAME}/.scalafmt.conf"
version = "2.7.4"
EOF

mkdir -p "${NAME}/.vscode/"
cat << EOF > "${NAME}/.vscode/launch.json"
{
  // Use IntelliSense to learn about possible attributes.
  // Hover to view descriptions of existing attributes.
  // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
  "version": "0.2.0",
  "configurations": [
    {
      "type": "scala",
      "name": "debug Hello1",
      "request": "launch",
      "mainClass": "Hello1",
      "buildTarget": "hello1",
      "args": []
    }
  ]
}
EOF

mkdir -p "${NAME}/bin/"
cat << EOF > "${NAME}/bin/hello1.sh"
#!/usr/bin/env bash
# set -x
XPATH=$(dirname $(readlink -f $0))
XFILE=${0##*/}
XBASE=${XFILE%.sh}
XJAR="${XPATH}/../package/hello1/target/scala-3.0.0-M1/hello1.jar"
if [ ! -f $XJAR ]; then
  pushd "${XPATH}/.."
  sbt hello1/assembly
  popd
fi
scala -jar "${XPATH}/../package/hello1/target/scala-3.0.0-M1/hello1.jar" "$@"
EOF

mkdir -p "${NAME}/"
cat << EOF > "${NAME}/build.sbt"
lazy val commonSettings = Seq(
  organization := "jlauman/mksc3",
  scalaVersion := "3.0.0-M1",
  libraryDependencies += "org.scalameta" %% "munit" % "0.7.17" % "test",
  testFrameworks += new TestFramework("munit.Framework"),
  test in assembly := {},
  logBuffered := true,
)

// lazy val root = (project in file("."))
//   .dependsOn(hello2, ModuleA)
//   .aggregate(hello2, ModuleA)
//   .settings(
//     name := "root",
//     organization := "my-organization",
//     version := "1.0.0",
//     commonSettings
//   )

lazy val hello1 = (project in file("package/hello1"))
  .settings(
    commonSettings,
    name := "hello1",
    version := "1.0.0",
    mainClass in assembly := Some("Hello1"),
    assemblyJarName in assembly := "hello1.jar"
  )

// lazy val hello3 = (project in file("product/hello3"))
//   .enablePlugins(ScalaJSPlugin)
//   .settings(
//     name := "hello3",
//     organization := "my-organization",
//     version := "1.0.0",
//     commonSettings,
//     scalaJSUseMainModuleInitializer := true
//   )

// lazy val ModuleA = (project in file("product/ModuleA"))
//   .settings(
//     name := "ModuleA",
//     organization := "my-organization",
//     version := "1.0.0",
//     commonSettings
//   )
EOF

mkdir -p "${NAME}/package/hello1/src/main/scala/"
cat << EOF > "${NAME}/package/hello1/src/main/scala/Hello1.scala"

@main def Hello1(names: String*) =
  val count = names.length
  println(s"Hello1: names=${names}")
  println(s"Hello1: count=${count}")
EOF

mkdir -p "${NAME}/project/"
cat << EOF > "${NAME}/project/build.properties"
sbt.version=1.4.2
EOF

mkdir -p "${NAME}/project/"
cat << EOF > "${NAME}/project/plugins.sbt"
addSbtPlugin("ch.epfl.lamp" % "sbt-dotty" % "0.4.6")
addSbtPlugin("org.scala-js" % "sbt-scalajs" % "1.3.0")
addSbtPlugin("com.eed3si9n" % "sbt-assembly" % "0.15.0")
addSbtPlugin("org.scalameta" % "sbt-mdoc" % "2.2.12")
EOF
