using OpenPixelControl;
using System.Collections.Generic;

// TODO: Separate the yielding and the sequence generation to respect the Single Responsibility principle
// TODO: Encode screen size and empty buffer when it goes offscreen (right now it appends more and more pixels indefinitely)

namespace Unity2OpenPixel
{
    /// <summary>
    ///  Rainbow Effect.
    ///  WARNING: Doesn't empty its buffer over time. Can't be let running over night!
    /// </summary>
    public class RainbowEffect : PixelEffect
    {
        public int BufferSize = 30;

        public override IEnumerator<PixelStrip> GenSequence()
        {
            PixelStrip pixels = new PixelStrip(BufferSize);

            while (true)
            {
                for (int i = 0; i <= 360; i = i + 5)
                {
                    var color = new HSLColor(hue: i, saturation: 100, luminosity: 100);

                    pixels.AddFirst(color.ToRgbPixel());

                    yield return pixels;
                }
            }
        }
    }
}
