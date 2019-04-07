using OpenPixelControl;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Unity2OpenPixel
{
    [System.Serializable]
    public class Controller
    {
        public string Ip = "192.168.42.125";
        public int Port = 7890;

        [Header("Modifiable during runtime")]
        public float Delay = .1f;
        public bool Running = true;

        private Client Client;

        public IEnumerator Run(PixelEffect effect)
        {
            Init();

            return Routine(effect);
        }

        private void Init()
        {
            Client = new OpenPixelControl.Client(
                Ip, Port,
                long_connecton: true,
                verbose: true
            );
        }

        public IEnumerator Routine(PixelEffect pixelEffect)
        {
            YieldInstruction preYieldInstruction = pixelEffect.PreCondition();

            if (preYieldInstruction != null)
                yield return preYieldInstruction;

            // Does it run the code until the first yield instruction?
            IEnumerator<PixelStrip> sequence = pixelEffect.GenSequence();

            while (true)
            {
                if (Running)
                {
                    preYieldInstruction = pixelEffect.PreCondition();

                    if(preYieldInstruction != null)
                        yield return preYieldInstruction;

                    sequence.MoveNext();
                    Update(sequence.Current);
                }

                // Not given as a parameter so it can easily be changed during playtime.
                yield return new WaitForSeconds(Delay);
            }
        }

        private void Update(PixelStrip pixelStrip)
        {
            Client.putPixels(pixelStrip);
        }
    }
}
