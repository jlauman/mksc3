import java.io.{File, FilenameFilter, PrintWriter}
import java.nio.file.Files
import java.nio.file.attribute.PosixFilePermissions
import scala.collection.mutable.StringBuilder
import scala.util.chaining._
import scala.io.Source

object MakeMksc3 {
  def main(args: Array[String]): Unit = {
    println("MakeMksc3: " + args.toList)
    val paths = "template"
      .pipe(getFileList)
      .pipe(filterFileList)
      .sortWith(_.toString < _.toString)
    paths.foreach(file => println(file.toString()))
    val sb = new StringBuilder()
    buildHeader(sb)
    paths.foreach(file => buildFromFile(sb, file))
    // println(sb.toString)
    val file = new File("mksc3.sh")
    val pw = new PrintWriter(file)
    pw.write(sb.toString)
    pw.close
    Files.setPosixFilePermissions(
      file.toPath(),
      PosixFilePermissions.fromString("rwxr-xr-x")
    )
  }
  def patterns(): List[String] = {
    List(
      "/build.sbt",
      "/.scalafmt.conf",
      "/.vscode/launch.json",
      "/project/build.properties",
      "/project/plugins.sbt",
      "/bin/",
      "/src/main/",
      "/src/test/"
    )
  }
  val filenameFilter = new FilenameFilter {
    override def accept(file: File, name: String): Boolean = {
      name != "target" && name != ".bloop"
    }
  }
  def getFileList(path: String): List[File] = {
    val d = new File(path)
    if (d.exists && d.isDirectory) {
      d.listFiles(filenameFilter)
        .toList
        .flatMap(file =>
          if (file.isFile) List(file)
          else getFileList(file.toString())
        )
    } else {
      List[File]()
    }
  }
  def filterFileList(files: List[File]): List[File] = {
    for (
      file <- files;
      pattern <- patterns() if file.toString().contains(pattern)
    ) yield file
  }
  def buildHeader(sb: StringBuilder): Unit = {
    sb.append("""#/usr/bin/env bash
    |set -e
    |
    |if [ "$#" -ne 1 ]; then
    |    echo "$0: project name argument required"
    |    exit 1
    |fi
    |
    |NAME=$1
    |
    """.stripMargin)
  }
  def buildFromFile(sb: StringBuilder, file: File): Unit = {
    val bufferedSource = Source.fromFile(file, "UTF-8")
    val contents = bufferedSource.mkString.replace("$", "\\$")
    bufferedSource.close()
    val name = file.getName()
    val path = file.toString().replace("template/", "${NAME}/")
    sb.append("\n")
    sb.append("mkdir -p \"" + path.replace(s"/${name}", "/") + "\"\n")
    sb.append("cat << EOF > \"" + path + "\"\n")
    sb.append(contents)
    sb.append("EOF\n")
  }
}
