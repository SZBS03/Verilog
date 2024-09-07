package task_2

//Task 3: Given two Array[Double] values of the same length, write a function that returns the elementwise sum. This is a new Array where each element is the sum of the values from the two input arrays at
//that location. So if you have Array(1,2,3) and Array(4,5,6) you will get back Array(5,7,9).

object part_3 {
  def VectorSum(i: Array[Double], j: Array[Double]): Option[Array[Double]] = {
    if (i.length == j.length) {
      Some(i.zip(j).map { case (a, b) => a + b })
    }
    else None
  }
    def main(args: Array[String]): Unit = {
      val array1 = Array(1.2, 1.3, 1.44)
      val array2 = Array(2.34, 23.45, 22)
      println(VectorSum(array1, array2))
      VectorSum(array1, array2) match {
        case Some(result) => println(s"VectorSum[${result.mkString(", ")}]")
        case None => println(s"[${array1.mkString(",")}] and [${array2.mkString(",")}] need to be of the same R ( dimensions )")
      }
    }
  }
