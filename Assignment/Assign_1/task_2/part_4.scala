package task_2

object part_4{
     def Even_Separator(i: Array[Int]): Array[Int] = {        //Even Separator by recursive function
       def EvenGen(a: Int, res: Array[Int]): Array[Int] = {
         if(a >= i.length){res}
         else{
         if (i(a)%2==0){
            EvenGen(a+1,res:+ i(a))
         }
         else EvenGen(a+1,res)
       }
       }
       EvenGen(0,Array())
     }

  def Partition_Even(i: Array[Int]): Array[Int] = { //Even Separator by High Order Methods
    val even = i.filter(x => x % 2 == 0)
    even
  }

     def main(args: Array[String]): Unit = {
       val array = Array(1,2,3,4,5,6,7,8)
       println(s"Even By Recursion = [${Even_Separator(array).mkString(", ")}]")
       println(s"Even By H.O.F = [${Partition_Even(array).mkString(", ")}]")
     }
}
