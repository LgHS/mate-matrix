using System.Collections.Generic;
using System.Linq;
using OpenPixelControl;
using UnityEngine;

[System.Serializable]
public class MateGrid
{
    public Vector2Int CrateSize;
    public Vector2Int GridSize;

    private List<Pixel> pixels;

    public int GetWidth()
        => CrateSize.x * GridSize.x;

    public int GetHeight() 
        => CrateSize.y * GridSize.y;

    public void InitMatrix()
    {
        pixels = new List<Pixel>(GetWidth() * GetHeight());

        for (int y = 0; y < GetHeight(); y++)
        {
            for (int x = 0; x < GetWidth(); x++)
            {
                pixels.Add(new Pixel(0, 0, 0));
            }
        }
    }

    public int GetGridIndex(int x, int y)
    {
        int ledsByCrate = CrateSize.x * CrateSize.y;

        // invert origin (unity 0,0 is at bottom left)
        y = GetHeight() - 1 - y;

        int crateX = x / CrateSize.x; // current crate in X
        int crateY = y / CrateSize.y; // current crate in Y
        int crateIndex = crateX + crateY * GridSize.x; // current crate index
        
        int xInCrate = x % CrateSize.x; // current LED in crate
        int yInCrate = y % CrateSize.y; // current LED in crate
        if (yInCrate % 2 == 1) xInCrate = CrateSize.x - xInCrate - 1; // invert for zigzag 

        // led index = index inside crate + all LEDs before
        int index = crateIndex * ledsByCrate + xInCrate + yInCrate * CrateSize.x;
        
        return index;
    }

    public Pixel GetPixel(int x, int y)
    {
        return pixels.ElementAt(GetGridIndex(x, y));
    }

    public void SetPixelAt(Pixel pixel, int x, int y)
    {
        int index = GetGridIndex(x, y);
        pixels[index] = pixel;
    }

    public List<Pixel> GetPixels()
    {
        return pixels;
    }
}