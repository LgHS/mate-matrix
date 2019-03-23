using UnityEngine;

[System.Serializable]
public class MateGrid
{
    public Vector2Int CrateSize;
    public Vector2Int GridSize;

    public int GetWidth()
        => CrateSize.x * GridSize.x;

    public int GetHeight() 
        => CrateSize.y * GridSize.y;

    public int Convert(int x, int y)
    {
        return 0;
    }
}