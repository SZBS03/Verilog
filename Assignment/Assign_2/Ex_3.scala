package ASSIGN2.task_1

object Ex_3 {

  def euclidean_vector(vec: Vector[Int], norm: Int): Double = {
    val dval = math.sqrt(vec.map(x => x * x).sum)
    def increament(i: Int, d : Double): Double = {
      if (i == norm) {
       d
      }
      else increament(i+1,d+dval)
    }
    increament(0,0.0)
  }

  def main(args: Array[String]): Unit = {
    println(euclidean_vector(Vector(1, 2, 3, 4, 5, 6),9))
  }
}