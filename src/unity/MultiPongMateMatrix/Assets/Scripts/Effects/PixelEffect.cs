using OpenPixelControl;
using System.Collections.Generic;
using UnityEngine;

namespace Unity2OpenPixel
{
    public abstract class PixelEffect : MonoBehaviour
    {
        public abstract IEnumerator<PixelStrip> GenSequence();

        /// <summary>
        /// <see cref="YieldInstruction"/> to be returned before getting next element in the sequence
        /// </summary>
        /// <returns>The <see cref="YieldInstruction"/> to be returned before fetching the next element in the sequence or null if none is required.</returns>
        public virtual YieldInstruction PreCondition() => null;
    }
}