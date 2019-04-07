using System.Collections.Generic;
using System.Linq;
using OpenPixelControl;
using UnityEngine;

namespace Unity2OpenPixel
{
    /// <summary>
    /// Grid made of smaller, nested grid units.
    /// </summary>
    [System.Serializable]
    public class DoubleGrid
    {
        public Vector2Int SubGridSize;
        public Vector2Int GridSize;

        private List<Pixel> Pixels;

        public int GetWidth()
            => SubGridSize.x * GridSize.x;

        public int GetHeight()
            => SubGridSize.y * GridSize.y;

        public void InitMatrix()
        {
            Pixels = new List<Pixel>(GetWidth() * GetHeight());

            for (int y = 0; y < GetHeight(); y++)
            {
                for (int x = 0; x < GetWidth(); x++)
                {
                    Pixels.Add(new Pixel(0, 0, 0));
                }
            }
        }

        public int GetGridIndex(int x, int y)
        {
            int pixelBySubGrid = SubGridSize.x * SubGridSize.y;

            // invert origin (unity 0,0 is at bottom left)
            y = GetHeight() - 1 - y;

            int subX = x / SubGridSize.x; // current crate in X
            int subY = y / SubGridSize.y; // current crate in Y
            int subIndex = subX + subY * GridSize.x; // current crate index

            int xInSubGrid = x % SubGridSize.x; // current LED in crate
            int yInSubGrid = y % SubGridSize.y; // current LED in crate
            if (yInSubGrid % 2 == 1) xInSubGrid = SubGridSize.x - xInSubGrid - 1; // invert for zigzag 

            // led index = index inside crate + all LEDs before
            int index = subIndex * pixelBySubGrid + xInSubGrid + yInSubGrid * SubGridSize.x;

            return index;
        }

        public Pixel GetPixel(int x, int y)
        {
            return Pixels.ElementAt(GetGridIndex(x, y));
        }

        public void SetPixelAt(Pixel pixel, int x, int y)
        {
            int index = GetGridIndex(x, y);
            Pixels[index] = pixel;
        }

        public PixelStrip GetPixels()
        {
            return (PixelStrip)new LinkedList<Pixel>(Pixels);
        }
    }
}