using Unity2OpenPixel;
using UnityEngine;

public class Main : MonoBehaviour
{
    public PixelEffect Effect;
    public Controller Unity2OpenPixelController;

    void Start()
    {
        StartCoroutine(Unity2OpenPixelController.Run(Effect));
    }
}
