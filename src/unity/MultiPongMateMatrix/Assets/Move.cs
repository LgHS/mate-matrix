using UnityEngine;

public class Move : MonoBehaviour
{
    public float Speed = 1f;

    // Update is called once per frame
    private void Update()
    {
        transform.Translate(
            Input.GetAxisRaw("Horizontal") * Speed,
            Input.GetAxisRaw("Vertical") * Speed,
            0
        );

//        if (Input.touchCount <= 0) return;

//        aTouch = Input.GetMouseButton(0);
//        touchPos = Input.mousePosition;

        bool aTouch;
        Vector2 touchPos;

        if (Application.platform != RuntimePlatform.Android)
        {
            aTouch = Input.GetMouseButton(0);
            touchPos = Input.mousePosition;
        }
        else
        {
            aTouch = Input.touchCount > 0;
            touchPos = Input.GetTouch(0).position;
        }

        if (aTouch)
        {
            transform.position = touchPos / 100;
        }
    }
}