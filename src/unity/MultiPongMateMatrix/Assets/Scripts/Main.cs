using OpenPixelControl;
using UnityEngine;

public class Main : MonoBehaviour
{
    public string Ip = "192.168.42.125";
    public int Port = 7890;

    [Header("Effect")]
    public PixelEffect PixelEffect;
    public float Delay = .1f;

    void Start()
    {
        Client client = new Client(Ip, Port, true, true);

        StartCoroutine(PixelEffect.Effect(client, Delay));
    }    
}
