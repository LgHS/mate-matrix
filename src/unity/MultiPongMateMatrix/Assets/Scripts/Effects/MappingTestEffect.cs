//using OpenPixelControl;
//using System.Collections;
//using System.Collections.Generic;
//using System.Linq;
//using UnityEngine;

//public class MappingTestEffect : PixelEffect
//{
//    [Header("Provided by " + nameof(Main))]
//    public float Delay;
//    public MateGrid Grid;
//    public bool loopThroughGrid;
//    public Vector2Int soloPixel;

//    public override IEnumerator Effect(Client client, float delay)
//    {
//        // So it can modified during runtime.
//        Delay = delay;
//        Grid.InitMatrix();

//        int currX = 0;
//        int currY = 0;

//        while (true)
//        {
//            for (int y = 0; y < Grid.GetHeight(); y++)
//            {
//                for (int x = 0; x < Grid.GetWidth(); x++)
//                {
//                    var pixel = Grid.GetPixel(x, y);
//                    byte col = 0;

//                    if (x == currX && y == currY)
//                        col = 255;
//                    pixel.r = col;
//                    pixel.g = col;
//                    pixel.b = col;
//                }
//            }

//            client.putPixels(Grid.GetPixels());


//            if (loopThroughGrid)
//            {
//                if (++currX >= Grid.GetWidth())
//                {
//                    currX = 0;

//                    if (++currY >= Grid.GetHeight()) currY = 0;
//                }
//            }
//            else
//            {
//                currX = soloPixel.x;
//                currY = soloPixel.y;
//            }

//            yield return new WaitForSeconds(Delay);
//        }
//    }
//}