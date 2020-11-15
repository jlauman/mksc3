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

lazy val hello2 = (project in file("package/hello2"))
  .enablePlugins(ScalaJSPlugin)
  .settings(
    commonSettings,
    name := "hello2",
    version := "1.0.0",
    mainClass in (Compile, run) := Some("Hello2"),
    scalaJSUseMainModuleInitializer := true
  )

// lazy val ModuleA = (project in file("product/ModuleA"))
//   .settings(
//     name := "ModuleA",
//     organization := "my-organization",
//     version := "1.0.0",
//     commonSettings
//   )
