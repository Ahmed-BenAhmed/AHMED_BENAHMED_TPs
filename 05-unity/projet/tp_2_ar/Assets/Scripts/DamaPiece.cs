using UnityEngine;

[DisallowMultipleComponent]
public class DamaPiece : MonoBehaviour
{
    Renderer bodyRenderer;
    Renderer accentRenderer;
    Vector3 initialScale;
    Color baseColor;

    public DamaSide Side { get; private set; }
    public bool IsKing { get; private set; }
    public DamaCoordinate Coordinate { get; private set; }

    public void Initialize(
        DamaSide side,
        DamaCoordinate coordinate,
        Renderer body,
        Renderer accent,
        Color color)
    {
        Side = side;
        Coordinate = coordinate;
        bodyRenderer = body;
        accentRenderer = accent;
        initialScale = transform.localScale;
        baseColor = color;

        SetRendererColor(bodyRenderer, baseColor);

        SetRendererColor(accentRenderer, Color.Lerp(baseColor, Color.white, 0.22f));
    }

    public void SetCoordinate(DamaCoordinate coordinate, Vector3 localPosition)
    {
        Coordinate = coordinate;
        transform.localPosition = localPosition;
    }

    public void SetSelected(bool isSelected)
    {
        transform.localScale = isSelected ? initialScale * 1.08f : initialScale;
        SetRendererColor(
            accentRenderer,
            isSelected
                ? Color.Lerp(baseColor, Color.yellow, 0.7f)
                : (IsKing ? new Color(1f, 0.8f, 0.15f) : Color.Lerp(baseColor, Color.white, 0.22f)));
    }

    public void PromoteToKing()
    {
        IsKing = true;
        if (accentRenderer != null)
        {
            accentRenderer.transform.localScale = new Vector3(0.018f, 0.002f, 0.018f);
            accentRenderer.transform.localPosition = new Vector3(0f, 0.006f, 0f);
            SetRendererColor(accentRenderer, new Color(1f, 0.8f, 0.15f));
        }
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
