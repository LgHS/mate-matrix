using OpenPixelControl;
using System.Collections;
using UnityEngine;

// TODO: Separate the yielding and the sequence generation to respect the Single Responsibility principle
// TODO: Encode screen size and empty buffer when it goes offscreen (right now it appends more and more pixels indefinitely)

public class RainbowEffect : PixelEffect
{
    [Header("Provided by " + nameof(Main))]
    public float Delay;
    public int BufferSize = 30;

    public override IEnumerator Effect(Client client, float delay)
    {
        // So it can modified during runtime.
        Delay = delay;
        PixelStrip pixels = new PixelStrip(BufferSize);

        while (true)
        {
            for (int i = 0; i <= 360; i = i + 5)
            {
                var color = new HSLColor(hue: i, saturation: 100, luminosity: 100);

                pixels.AddFirst(color.ToRgbPixel());
                client.putPixels(pixels);

                yield return new WaitForSeconds(Delay);
            }
        }
    }
}
