object Hello2 {
  def main(args: Array[String]): Unit = {
    val count = args.length
    println(s"Hello2: names=${args.toList}")
    println(s"Hello2: count=${count}")
  }
}
