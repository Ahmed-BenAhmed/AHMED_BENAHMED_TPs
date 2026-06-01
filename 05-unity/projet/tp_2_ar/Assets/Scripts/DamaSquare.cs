using UnityEngine;

[DisallowMultipleComponent]
public class DamaSquare : MonoBehaviour
{
    Renderer squareRenderer;
    Vector3 initialScale;
    Color baseColor;

    public DamaCoordinate Coordinate { get; private set; }

    public void Initialize(int row, int col, Renderer renderer, Color color)
    {
        Coordinate = new DamaCoordinate(row, col);
        squareRenderer = renderer;
        initialScale = transform.localScale;
        baseColor = color;
        ApplyVisual(DamaSquareVisualState.Default);
    }

    public void ApplyVisual(DamaSquareVisualState state)
    {
        if (squareRenderer == null)
            squareRenderer = GetComponent<Renderer>();

        if (squareRenderer == null)
            return;

        Color targetColor = baseColor;
        float heightScale = 1f;

        switch (state)
        {
            case DamaSquareVisualState.Selected:
                targetColor = Color.Lerp(baseColor, new Color(1f, 0.95f, 0.35f), 0.75f);
                heightScale = 1.8f;
                break;
            case DamaSquareVisualState.LegalTarget:
                targetColor = Color.Lerp(baseColor, new Color(0.15f, 0.75f, 0.25f), 0.7f);
                heightScale = 1.4f;
                break;
            case DamaSquareVisualState.HintSource:
                targetColor = Color.Lerp(baseColor, new Color(0.15f, 0.6f, 1f), 0.7f);
                heightScale = 1.3f;
                break;
            case DamaSquareVisualState.HintTarget:
                targetColor = Color.Lerp(baseColor, new Color(0.85f, 0.4f, 1f), 0.75f);
                heightScale = 1.6f;
                break;
        }

        SetRendererColor(squareRenderer, targetColor);
        transform.localScale = new Vector3(initialScale.x, initialScale.y * heightScale, initialScale.z);
    }

    void SetRendererColor(Renderer renderer, Color color)
    {
        if (renderer == null)
            return;

        if (Application.isPlaying)
            renderer.material.color = color;
        else if (renderer.sharedMaterial != null)
            renderer.sharedMaterial.color = color;
    }
}
