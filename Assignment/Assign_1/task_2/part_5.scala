package task_2

object part_5 {
  def buildMap[A, B](data: Seq[A], f: A => B): Map[A, B] = {
    data.map(a => a -> f(a)).toMap            // function f(a) makes keys from values a
  }

  def main(args: Array[String]): Unit = {
    val seq1 = Seq(1, 2, 3, 4, 5, 6)
    val seq2 = Seq("fame","fold","turf")
    def func1(x: Int): Boolean = x % 2 == 0
    println(buildMap(seq1, func1))
    def func2(x: String): String = x.replaceFirst("f", "s")
    println(buildMap(seq2, func2))
  }
}
