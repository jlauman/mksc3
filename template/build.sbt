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
