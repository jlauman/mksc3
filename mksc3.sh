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
XPATH=\$(dirname \$(readlink -f \$0))
XFILE=\${0##*/}
XBASE=\${XFILE%.sh}
XJAR="\${XPATH}/../package/hello1/target/scala-3.0.0-M2/hello1.jar"
if [ ! -f \$XJAR ]; then
  pushd "\${XPATH}/.."
  sbt hello1/assembly
  popd
fi
scala -jar "\${XPATH}/../package/hello1/target/scala-3.0.0-M2/hello1.jar" "\$@"
EOF

mkdir -p "${NAME}/bin/"
cat << EOF > "${NAME}/bin/hello2.sh"
#!/usr/bin/env bash
# set -x
set -e
XPATH=\$(dirname \$(readlink -f \$0))
XFILE=\${0##*/}
XBASE=\${XFILE%.sh}
XMAIN="\${XPATH}/../package/hello2/target/scala-3.0.0-M2/hello2-opt/main.js"
if [ ! -f \$XMAIN ]; then
  pushd "\${XPATH}/.."
  sbt hello2/fullLinkJS
  popd
fi
node "\$XMAIN" "\$@"
EOF

mkdir -p "${NAME}/bin/"
cat << EOF > "${NAME}/bin/hello3.sh"
#!/usr/bin/env bash
# set -x
set -e
XPATH=\$(dirname \$(readlink -f \$0))
XFILE=\${0##*/}
XBASE=\${XFILE%.sh}
sbt "hello3/clean" "show hello3/fullLinkJS"
node -i -e "import('\${XPATH}/../package/hello3/target/scala-3.0.0-M2/hello3-opt/hello3.js').then(module => global.Hello3 = module.Hello3);"
# Hello3.hello('world!')
EOF

mkdir -p "${NAME}/"
cat << EOF > "${NAME}/build.sbt"
lazy val commonSettings = Seq(
  organization := "jlauman/mksc3",
  scalaVersion := "3.0.0-M2",
  libraryDependencies += "org.scalameta" %% "munit" % "0.7.19" % "test",
  testFrameworks += new TestFramework("munit.Framework"),
  test in assembly := {},
  logBuffered := true
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

lazy val hello2 = (project in file("package/hello2"))
  .enablePlugins(ScalaJSPlugin)
  .settings(
    commonSettings,
    name := "hello2",
    version := "1.0.0",
    mainClass in (Compile, run) := Some("Hello2"),
    scalaJSUseMainModuleInitializer := true
  )

lazy val hello3 = (project in file("package/hello3"))
  .enablePlugins(ScalaJSPlugin)
  .settings(
    commonSettings,
    name := "hello3",
    version := "1.0.0",
    scalaJSLinkerConfig ~= { _.withModuleKind(ModuleKind.ESModule) }
  )

lazy val french_date = (project in file("package/french_date"))
  .settings(
    commonSettings,
    name := "french_date",
    version := "1.0.0",
    mainClass in (Compile, run) := Some("FrenchDate")
  )

lazy val timer = (project in file("package/timer"))
  .settings(
    commonSettings,
    name := "timer",
    version := "1.0.0",
    mainClass in (Compile, run) := Some("Timer"),
    // allow Ctrl+C to stop program
    fork in run := true
  )

// lazy val ModuleA = (project in file("product/ModuleA"))
//   .settings(
//     name := "ModuleA",
//     organization := "my-organization",
//     version := "1.0.0",
//     commonSettings
//   )
EOF

mkdir -p "${NAME}/package/french_date/src/main/scala/"
cat << EOF > "${NAME}/package/french_date/src/main/scala/FrenchDate.scala"
/** Show interacting Java libraries.
  *
  * see: https://docs.scala-lang.org/tutorials/scala-for-java-programmers.html
  */
import java.util.{Date, Locale}
import java.text.DateFormat._

object FrenchDate {
  def main(args: Array[String]): Unit = {
    val now = new Date
    val df = getDateInstance(LONG, Locale.FRANCE)
    println(df format now)
  }
}
EOF

mkdir -p "${NAME}/package/hello1/src/main/scala/"
cat << EOF > "${NAME}/package/hello1/src/main/scala/Hello1.scala"

@main def Hello1(names: String*) =
  val count = names.length
  println(s"Hello1: names=\${names}")
  println(s"Hello1: count=\${count}")
EOF

mkdir -p "${NAME}/package/hello2/src/main/scala/"
cat << EOF > "${NAME}/package/hello2/src/main/scala/Hello2.scala"
object Hello2 {
  def main(args: Array[String]): Unit = {
    val count = args.length
    println(s"Hello2: names=\${args.toList}")
    println(s"Hello2: count=\${count}")
  }
}
EOF

mkdir -p "${NAME}/package/hello3/"
cat << EOF > "${NAME}/package/hello3/main.js"
import { Hello3 } from './target/scala-3.0.0-M2/hello3-opt/hello3.js';

console.log(Hello3.hello("world"));
EOF

mkdir -p "${NAME}/package/hello3/"
cat << EOF > "${NAME}/package/hello3/package.json"
{
  "name": "hello3",
  "version": "1.0.0",
  "description": "test scala.js exports",
  "main": "main.js",
  "type": "module",
  "scripts": {
    "start": "node main.js",
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "keywords": [
    "scala",
    "js",
    "export"
  ],
  "author": "Jason Lauman",
  "license": "MIT"
}
EOF

mkdir -p "${NAME}/package/hello3/src/main/scala/"
cat << EOF > "${NAME}/package/hello3/src/main/scala/Hello3.scala"
import scala.scalajs.js
import scala.scalajs.js.annotation._

@JSExportTopLevel(name = "Hello3", moduleID = "hello3")
object Hello3 {

  @JSExport
  def hello(name: String): Unit = {
    println(s"Hello3: Hello \${name}!")
    var args: List[String] = List("one", "two", "three")
    val count = args.length
    println(s"Hello3: names=\${args.toList}")
    println(s"Hello3: count=\${count}")
  }
}
EOF

mkdir -p "${NAME}/package/timer/src/main/scala/"
cat << EOF > "${NAME}/package/timer/src/main/scala/Timer.scala"
object Timer {
  def oncePerSecond(callback: () => Unit): Unit = {
    while (true) { callback(); Thread sleep 1000 }
  }
  def timeFlies(): Unit = {
    println("time flies like an arrow...")
  }
  def main(args: Array[String]): Unit = {
    oncePerSecond(timeFlies)
  }
}
EOF

mkdir -p "${NAME}/project/"
cat << EOF > "${NAME}/project/build.properties"
sbt.version=1.4.3
EOF

mkdir -p "${NAME}/project/"
cat << EOF > "${NAME}/project/plugins.sbt"
addSbtPlugin("ch.epfl.lamp" % "sbt-dotty" % "0.4.6")
addSbtPlugin("org.scala-js" % "sbt-scalajs" % "1.3.0")
addSbtPlugin("com.eed3si9n" % "sbt-assembly" % "0.15.0")
addSbtPlugin("org.scalameta" % "sbt-mdoc" % "2.2.12")
EOF
