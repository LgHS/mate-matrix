using OpenPixelControl;
using System.Collections;
using UnityEngine;

public abstract class PixelEffect : MonoBehaviour
{
    public abstract IEnumerator Effect(Client client, float delay);

}