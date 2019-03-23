using UnityEngine;

public class Move : MonoBehaviour
{
    public float Speed = 1f;

    // Update is called once per frame
    void Update()
    {
        transform.Translate(
            Input.GetAxisRaw("Horizontal") * Speed,
            Input.GetAxisRaw("Vertical") * Speed,
            0
        );
    }
}
