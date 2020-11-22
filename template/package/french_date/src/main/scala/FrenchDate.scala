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
