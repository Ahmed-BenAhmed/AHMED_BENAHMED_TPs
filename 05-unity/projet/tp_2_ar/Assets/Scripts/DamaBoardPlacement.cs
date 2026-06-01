using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR.ARFoundation;
using UnityEngine.XR.ARSubsystems;

[ExecuteAlways]
[RequireComponent(typeof(ARAnchorManager))]
[RequireComponent(typeof(ARRaycastManager))]
public class DamaBoardPlacement : MonoBehaviour
{
    const string EditorPreviewName = "Editor Preview Board";
    const string RuntimeBoardName = "Dama AR Prototype";

    [SerializeField]
    float boardWorldSize = 0.32f;

    [SerializeField]
    float standHeight = 0.03f;

    [SerializeField]
    float boardThickness = 0.012f;

    [SerializeField]
    Color darkSquareColor = new Color(0.17f, 0.11f, 0.07f);

    [SerializeField]
    Color lightSquareColor = new Color(0.92f, 0.84f, 0.67f);

    [SerializeField]
    Color playerOneColor = new Color(0.78f, 0.18f, 0.15f);

    [SerializeField]
    Color playerTwoColor = new Color(0.18f, 0.18f, 0.18f);

    [SerializeField]
    bool showEditorPreview = true;

    [SerializeField]
    Vector3 editorPreviewOffset = new Vector3(0f, -0.12f, 0.95f);

    [SerializeField]
    Vector3 desktopFallbackOffset = new Vector3(0f, -0.14f, 1.05f);

    [SerializeField]
    float statusTextHeight = 0.24f;

    [SerializeField]
    float statusTextForwardOffset = 0.24f;

    GameObject boardRoot;
    ARRaycastManager raycastManager;
    Camera placementCamera;
    IDamaAnalysisEngine analysisEngine;

    readonly DamaSquare[,] squares = new DamaSquare[8, 8];
    readonly DamaPiece[,] pieces = new DamaPiece[8, 8];
    readonly List<DamaMoveSuggestion> selectedPieceMoves = new List<DamaMoveSuggestion>();

    DamaSide currentTurn = DamaSide.PlayerOne;
    DamaPiece selectedPiece;
    DamaMoveSuggestion hintMove;
    bool hasHintMove;
    GameObject hintMarker;
    TextMesh statusText;
    Transform statusTransform;
    bool editorPreviewDirty;

    static readonly List<ARRaycastHit> Hits = new List<ARRaycastHit>();

    float CellSize => boardWorldSize / 8f;
    float BoardFrameY => standHeight + 0.018f;
    float PieceHeight => 0.012f;
    float PieceDiameter => CellSize * 0.72f;
    float SquareThickness => 0.002f;

    void Awake()
    {
        raycastManager = GetComponent<ARRaycastManager>();
        RefreshCameraReference();
        analysisEngine = new HeuristicDamaAnalysisEngine();
    }

    void OnEnable()
    {
        if (Application.isPlaying)
        {
            RemoveEditorPreview();
            return;
        }

        editorPreviewDirty = true;
    }

    void OnValidate()
    {
        if (!Application.isPlaying)
            editorPreviewDirty = true;
    }

    void Update()
    {
        if (!Application.isPlaying)
        {
            if (editorPreviewDirty)
            {
                editorPreviewDirty = false;
                RebuildEditorPreview();
            }

            UpdateBoardPresentation();

            return;
        }

        UpdateBoardPresentation();

        if (boardRoot == null && !HasPlanePlacementSupport())
        {
            CreateDesktopFallbackBoard();
            return;
        }

        if (!TryGetPointerDownPosition(out var screenPosition))
            return;

        if (boardRoot == null)
        {
            TryPlaceBoard(screenPosition);
            return;
        }

        HandleBoardTap(screenPosition);
    }

    bool HasPlanePlacementSupport()
    {
        return raycastManager != null && raycastManager.subsystem != null;
    }

    void CreateDesktopFallbackBoard()
    {
        boardRoot = CreatePrototypeRoot(RuntimeBoardName, isPreview: false);
        boardRoot.transform.SetParent(transform, false);
        boardRoot.transform.localPosition = desktopFallbackOffset;
        boardRoot.transform.localRotation = Quaternion.identity;

        currentTurn = DamaSide.PlayerOne;
        ClearSelection();
        UpdateHintSuggestion();
        RefreshVisuals();
        UpdateBoardPresentation();
        SetStatus("Desktop fallback active. Click pieces to test moves without AR plane detection.");
    }

    void RebuildEditorPreview()
    {
        RemoveEditorPreviewImmediate();
        ClearBoardReferences();

        if (!showEditorPreview)
            return;

        boardRoot = CreatePrototypeRoot(EditorPreviewName, isPreview: true);
        boardRoot.transform.SetParent(transform, false);
        boardRoot.transform.localPosition = editorPreviewOffset;
        boardRoot.transform.localRotation = Quaternion.identity;

        currentTurn = DamaSide.PlayerOne;
        ClearSelection();
        UpdateHintSuggestion();
        RefreshVisuals();
        UpdateBoardPresentation();
        SetStatus("Editor preview. On device: scan a table, tap once to place, then tap pieces to move.");
    }

    void RemoveEditorPreview()
    {
        var preview = transform.Find(EditorPreviewName);
        if (preview != null)
            Destroy(preview.gameObject);

        if (boardRoot != null && boardRoot.name == EditorPreviewName)
            ClearBoardReferences();
    }

    void RemoveEditorPreviewImmediate()
    {
        var preview = transform.Find(EditorPreviewName);
        if (preview != null)
            DestroyImmediate(preview.gameObject);

        if (boardRoot != null && boardRoot.name == EditorPreviewName)
            ClearBoardReferences();
    }

    void ClearBoardReferences()
    {
        boardRoot = null;
        hintMarker = null;
        statusText = null;
        statusTransform = null;
        selectedPiece = null;
        selectedPieceMoves.Clear();
        hasHintMove = false;

        for (int row = 0; row < 8; row++)
        {
            for (int col = 0; col < 8; col++)
            {
                squares[row, col] = null;
                pieces[row, col] = null;
            }
        }
    }

    bool TryGetPointerDownPosition(out Vector2 screenPosition)
    {
        if (Input.touchCount > 0)
        {
            var touch = Input.GetTouch(0);
            if (touch.phase == TouchPhase.Began)
            {
                screenPosition = touch.position;
                return true;
            }
        }

        if (Input.GetMouseButtonDown(0))
        {
            screenPosition = Input.mousePosition;
            return true;
        }

        screenPosition = default;
        return false;
    }

    void TryPlaceBoard(Vector2 screenPosition)
    {
        if (!raycastManager.Raycast(screenPosition, Hits, TrackableType.PlaneWithinPolygon))
            return;

        var hitPose = Hits[0].pose;
        if (Vector3.Dot(hitPose.up, Vector3.up) < 0.85f)
            return;

        boardRoot = CreatePrototypeRoot(RuntimeBoardName, isPreview: false);
        boardRoot.transform.SetPositionAndRotation(hitPose.position, GetPlacementRotation(hitPose));

        if (boardRoot.GetComponent<ARAnchor>() == null)
            boardRoot.AddComponent<ARAnchor>();

        currentTurn = DamaSide.PlayerOne;
        ClearSelection();
        UpdateHintSuggestion();
        RefreshVisuals();
        UpdateBoardPresentation();
        SetStatus("Board placed. Red plays first. Tap a red piece to see legal moves.");
    }

    Quaternion GetPlacementRotation(Pose hitPose)
    {
        RefreshCameraReference();
        if (placementCamera == null)
            return hitPose.rotation;

        var flattenedForward = Vector3.ProjectOnPlane(placementCamera.transform.forward, Vector3.up);
        if (flattenedForward.sqrMagnitude < 0.001f)
            flattenedForward = hitPose.rotation * Vector3.forward;

        return Quaternion.LookRotation(flattenedForward.normalized, Vector3.up);
    }

    void HandleBoardTap(Vector2 screenPosition)
    {
        RefreshCameraReference();

        if (placementCamera == null)
            return;

        Ray ray = placementCamera.ScreenPointToRay(screenPosition);
        if (!Physics.Raycast(ray, out var hit, 10f))
            return;

        DamaSquare tappedSquare = hit.collider.GetComponent<DamaSquare>();
        if (tappedSquare == null)
        {
            DamaPiece tappedPiece = hit.collider.GetComponentInParent<DamaPiece>();
            if (tappedPiece != null)
                tappedSquare = squares[tappedPiece.Coordinate.Row, tappedPiece.Coordinate.Col];
        }

        if (tappedSquare != null)
            HandleSquareTapped(tappedSquare);
    }

    void HandleSquareTapped(DamaSquare tappedSquare)
    {
        DamaCoordinate coordinate = tappedSquare.Coordinate;
        DamaPiece tappedPiece = pieces[coordinate.Row, coordinate.Col];

        if (selectedPiece == null)
        {
            if (tappedPiece == null)
            {
                SetStatus($"{DescribeSide(currentTurn)} to move. Tap one of its pieces.");
                return;
            }

            if (tappedPiece.Side != currentTurn)
            {
                SetStatus($"It is {DescribeSide(currentTurn)}'s turn.");
                return;
            }

            SelectPiece(tappedPiece);
            return;
        }

        if (tappedPiece == selectedPiece)
        {
            ClearSelection();
            RefreshVisuals();
            SetStatus("Selection cleared.");
            return;
        }

        if (TryGetMoveTo(coordinate, out var selectedMove))
        {
            ApplyMove(selectedMove);
            return;
        }

        if (tappedPiece != null && tappedPiece.Side == currentTurn)
        {
            SelectPiece(tappedPiece);
            return;
        }

        SetStatus("That square is not a legal destination.");
    }

    void SelectPiece(DamaPiece piece)
    {
        ClearSelection();

        var allLegalMoves = DamaRulebook.GetLegalMoves(BuildSnapshot(), currentTurn);
        foreach (var move in allLegalMoves)
        {
            if (move.From == piece.Coordinate)
                selectedPieceMoves.Add(move);
        }

        if (selectedPieceMoves.Count == 0)
        {
            SetStatus($"No legal move available from {piece.Coordinate.ToNotation()}.");
            return;
        }

        selectedPiece = piece;
        RefreshVisuals();
        SetStatus($"{DescribeSide(currentTurn)} selected {piece.Coordinate.ToNotation()}. Green squares are legal targets.");
    }

    bool TryGetMoveTo(DamaCoordinate target, out DamaMoveSuggestion move)
    {
        for (int i = 0; i < selectedPieceMoves.Count; i++)
        {
            if (selectedPieceMoves[i].To == target)
            {
                move = selectedPieceMoves[i];
                return true;
            }
        }

        move = default;
        return false;
    }

    void ApplyMove(DamaMoveSuggestion move)
    {
        DamaPiece movingPiece = pieces[move.From.Row, move.From.Col];
        if (movingPiece == null)
            return;

        pieces[move.From.Row, move.From.Col] = null;
        pieces[move.To.Row, move.To.Col] = movingPiece;

        if (move.IsCapture && move.HasCapturedPiece)
        {
            var capturedPiece = pieces[move.Captured.Row, move.Captured.Col];
            pieces[move.Captured.Row, move.Captured.Col] = null;
            if (capturedPiece != null)
                SafeDestroy(capturedPiece.gameObject);
        }

        movingPiece.SetCoordinate(move.To, GetPieceLocalPosition(move.To.Row, move.To.Col));

        if (!movingPiece.IsKing)
        {
            bool reachesPromotionRow =
                (movingPiece.Side == DamaSide.PlayerOne && move.To.Row == 0) ||
                (movingPiece.Side == DamaSide.PlayerTwo && move.To.Row == 7);

            if (reachesPromotionRow)
                movingPiece.PromoteToKing();
        }

        if (move.IsCapture)
        {
            var continuationMoves = DamaRulebook.GetContinuationCaptures(BuildSnapshot(), move.To);
            if (continuationMoves.Count > 0)
            {
                selectedPiece = movingPiece;
                selectedPieceMoves.Clear();
                selectedPieceMoves.AddRange(continuationMoves);
                RefreshVisuals();
                SetStatus($"Capture again from {move.To.ToNotation()}.");
                return;
            }
        }

        currentTurn = currentTurn == DamaSide.PlayerOne ? DamaSide.PlayerTwo : DamaSide.PlayerOne;
        ClearSelection();
        UpdateHintSuggestion();
        RefreshVisuals();
        SetStatus($"{DescribeSide(currentTurn)} to move. Suggested line: {GetHintDescription()}");
    }

    void ClearSelection()
    {
        selectedPiece = null;
        selectedPieceMoves.Clear();
    }

    void UpdateHintSuggestion()
    {
        if (analysisEngine == null)
            analysisEngine = new HeuristicDamaAnalysisEngine();

        hasHintMove = analysisEngine.TrySuggestMove(BuildSnapshot(), out hintMove);
    }

    void RefreshVisuals()
    {
        for (int row = 0; row < 8; row++)
        {
            for (int col = 0; col < 8; col++)
            {
                DamaSquare square = squares[row, col];
                if (square == null)
                    continue;

                DamaSquareVisualState visualState = DamaSquareVisualState.Default;

                if (hasHintMove)
                {
                    if (square.Coordinate == hintMove.From)
                        visualState = DamaSquareVisualState.HintSource;
                    else if (square.Coordinate == hintMove.To)
                        visualState = DamaSquareVisualState.HintTarget;
                }

                for (int i = 0; i < selectedPieceMoves.Count; i++)
                {
                    if (selectedPieceMoves[i].To == square.Coordinate)
                    {
                        visualState = DamaSquareVisualState.LegalTarget;
                        break;
                    }
                }

                if (selectedPiece != null && selectedPiece.Coordinate == square.Coordinate)
                    visualState = DamaSquareVisualState.Selected;

                square.ApplyVisual(visualState);
            }
        }

        for (int row = 0; row < 8; row++)
        {
            for (int col = 0; col < 8; col++)
            {
                DamaPiece piece = pieces[row, col];
                if (piece != null)
                    piece.SetSelected(piece == selectedPiece);
            }
        }

        if (hintMarker != null)
        {
            hintMarker.SetActive(hasHintMove);
            if (hasHintMove)
                hintMarker.transform.localPosition = GetHintMarkerPosition(hintMove.To.Row, hintMove.To.Col);
        }
    }

    DamaBoardSnapshot BuildSnapshot()
    {
        var snapshot = new DamaBoardSnapshot
        {
            SideToMove = currentTurn
        };

        for (int row = 0; row < 8; row++)
        {
            for (int col = 0; col < 8; col++)
            {
                DamaPiece piece = pieces[row, col];
                snapshot.Cells[row, col] = new DamaPieceState
                {
                    IsOccupied = piece != null,
                    Side = piece != null ? piece.Side : DamaSide.PlayerOne,
                    IsKing = piece != null && piece.IsKing
                };
            }
        }

        return snapshot;
    }

    string DescribeSide(DamaSide side)
    {
        return side == DamaSide.PlayerOne ? "Red" : "Black";
    }

    string GetHintDescription()
    {
        return hasHintMove ? hintMove.ToShortString() : "no legal move available";
    }

    GameObject CreatePrototypeRoot(string rootName, bool isPreview)
    {
        var root = new GameObject(rootName);
        var boardParent = new GameObject("Board").transform;
        boardParent.SetParent(root.transform, false);

        var standParent = new GameObject("Stand").transform;
        standParent.SetParent(root.transform, false);

        BuildStand(standParent);
        BuildBoard(boardParent);
        BuildPieces(boardParent);
        BuildHintMarker(root.transform);
        BuildStatusText(root.transform, isPreview);
        return root;
    }

    void BuildStand(Transform parent)
    {
        var standTopSize = boardWorldSize + 0.08f;
        var topThickness = 0.012f;
        var legWidth = 0.02f;
        var legHeight = standHeight;
        var topCenterY = legHeight + topThickness * 0.5f;

        CreatePrimitive(
            "StandTop",
            PrimitiveType.Cube,
            parent,
            new Vector3(0f, topCenterY, 0f),
            new Vector3(standTopSize, topThickness, standTopSize),
            new Color(0.43f, 0.26f, 0.14f));

        float legOffset = (standTopSize * 0.5f) - (legWidth * 1.5f);
        var legScale = new Vector3(legWidth, legHeight, legWidth);
        var legColor = new Color(0.34f, 0.19f, 0.1f);
        var legY = legHeight * 0.5f;

        CreatePrimitive("LegFrontLeft", PrimitiveType.Cube, parent, new Vector3(-legOffset, legY, legOffset), legScale, legColor);
        CreatePrimitive("LegFrontRight", PrimitiveType.Cube, parent, new Vector3(legOffset, legY, legOffset), legScale, legColor);
        CreatePrimitive("LegBackLeft", PrimitiveType.Cube, parent, new Vector3(-legOffset, legY, -legOffset), legScale, legColor);
        CreatePrimitive("LegBackRight", PrimitiveType.Cube, parent, new Vector3(legOffset, legY, -legOffset), legScale, legColor);
    }

    void BuildBoard(Transform parent)
    {
        CreatePrimitive(
            "BoardFrame",
            PrimitiveType.Cube,
            parent,
            new Vector3(0f, BoardFrameY, 0f),
            new Vector3(boardWorldSize + 0.025f, boardThickness, boardWorldSize + 0.025f),
            new Color(0.36f, 0.22f, 0.12f));

        for (int row = 0; row < 8; row++)
        {
            for (int col = 0; col < 8; col++)
            {
                Color squareColor = ((row + col) % 2 == 0) ? lightSquareColor : darkSquareColor;
                Vector3 localPosition = GetSquareLocalPosition(row, col);

                GameObject squareObject = CreatePrimitive(
                    $"Square_{row}_{col}",
                    PrimitiveType.Cube,
                    parent,
                    localPosition,
                    new Vector3(CellSize, SquareThickness, CellSize),
                    squareColor);

                var square = squareObject.AddComponent<DamaSquare>();
                square.Initialize(row, col, squareObject.GetComponent<Renderer>(), squareColor);
                squares[row, col] = square;
            }
        }
    }

    void BuildPieces(Transform parent)
    {
        var pieceParent = new GameObject("Pieces").transform;
        pieceParent.SetParent(parent, false);

        for (int row = 0; row < 3; row++)
            CreatePiecesForRow(pieceParent, row, DamaSide.PlayerTwo, playerTwoColor);

        for (int row = 5; row < 8; row++)
            CreatePiecesForRow(pieceParent, row, DamaSide.PlayerOne, playerOneColor);
    }

    void CreatePiecesForRow(Transform parent, int row, DamaSide side, Color color)
    {
        for (int col = 0; col < 8; col++)
        {
            if ((row + col) % 2 == 0)
                continue;

            GameObject pieceObject = CreatePrimitive(
                $"Piece_{row}_{col}",
                PrimitiveType.Cylinder,
                parent,
                GetPieceLocalPosition(row, col),
                new Vector3(PieceDiameter, PieceHeight * 0.5f, PieceDiameter),
                color);

            GameObject accentObject = CreatePrimitive(
                $"PieceAccent_{row}_{col}",
                PrimitiveType.Cylinder,
                pieceObject.transform,
                new Vector3(0f, PieceHeight * 0.35f, 0f),
                new Vector3(PieceDiameter * 0.62f, PieceHeight * 0.1f, PieceDiameter * 0.62f),
                Color.Lerp(color, Color.white, 0.22f));

            var accentCollider = accentObject.GetComponent<Collider>();
            if (accentCollider != null)
                SafeDestroy(accentCollider);

            var piece = pieceObject.AddComponent<DamaPiece>();
            piece.Initialize(
                side,
                new DamaCoordinate(row, col),
                pieceObject.GetComponent<Renderer>(),
                accentObject.GetComponent<Renderer>(),
                color);

            pieces[row, col] = piece;
        }
    }

    void BuildHintMarker(Transform parent)
    {
        hintMarker = CreatePrimitive(
            "AIHintMarker",
            PrimitiveType.Sphere,
            parent,
            new Vector3(0f, standHeight + 0.11f, 0f),
            new Vector3(0.022f, 0.007f, 0.022f),
            new Color(0.2f, 0.72f, 0.95f));
    }

    void BuildStatusText(Transform parent, bool isPreview)
    {
        var statusObject = new GameObject("BoardStatus");
        statusObject.transform.SetParent(parent, false);
        statusObject.transform.localPosition = new Vector3(0f, statusTextHeight, statusTextForwardOffset);
        statusObject.transform.localRotation = Quaternion.identity;
        statusTransform = statusObject.transform;

        statusText = statusObject.AddComponent<TextMesh>();
        statusText.anchor = TextAnchor.MiddleCenter;
        statusText.alignment = TextAlignment.Center;
        statusText.characterSize = 0.008f;
        statusText.fontSize = 48;
        statusText.color = isPreview ? new Color(0.95f, 0.95f, 0.95f) : new Color(0.9f, 1f, 0.9f);
        statusText.text = isPreview ? "Editor preview" : "Scan a surface to place the board.";
    }

    void SetStatus(string message)
    {
        if (statusText != null)
            statusText.text = message;
    }

    GameObject CreatePrimitive(
        string name,
        PrimitiveType primitiveType,
        Transform parent,
        Vector3 localPosition,
        Vector3 localScale,
        Color color)
    {
        var instance = GameObject.CreatePrimitive(primitiveType);
        instance.name = name;
        instance.transform.SetParent(parent, false);
        instance.transform.localPosition = localPosition;
        instance.transform.localRotation = Quaternion.identity;
        instance.transform.localScale = localScale;

        var renderer = instance.GetComponent<Renderer>();
        if (renderer != null)
        {
            renderer.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.On;
            renderer.receiveShadows = true;
            EnsureRendererMaterial(renderer);
            SetRendererColor(renderer, color);
        }

        return instance;
    }

    Vector3 GetSquareLocalPosition(int row, int col)
    {
        return new Vector3(
            (col - 3.5f) * CellSize,
            BoardFrameY + boardThickness * 0.5f,
            (row - 3.5f) * CellSize);
    }

    Vector3 GetPieceLocalPosition(int row, int col)
    {
        return new Vector3(
            (col - 3.5f) * CellSize,
            BoardFrameY + boardThickness * 0.5f + SquareThickness + PieceHeight * 0.5f,
            (row - 3.5f) * CellSize);
    }

    Vector3 GetHintMarkerPosition(int row, int col)
    {
        return new Vector3(
            (col - 3.5f) * CellSize,
            standHeight + 0.11f,
            (row - 3.5f) * CellSize);
    }

    void UpdateBoardPresentation()
    {
        if (boardRoot == null)
            return;

        RefreshCameraReference();
        UpdateStatusTransform();
    }

    void UpdateStatusTransform()
    {
        if (statusTransform == null || placementCamera == null)
            return;

        Vector3 directionToCamera = statusTransform.position - placementCamera.transform.position;
        if (directionToCamera.sqrMagnitude < 0.0001f)
            return;

        statusTransform.rotation = Quaternion.LookRotation(directionToCamera.normalized, Vector3.up);
        statusTransform.Rotate(0f, 180f, 0f, Space.Self);
    }

    void RefreshCameraReference()
    {
        if (placementCamera != null && placementCamera.gameObject.activeInHierarchy)
            return;

        placementCamera = Camera.main != null ? Camera.main : FindFirstObjectByType<Camera>();
    }

    void SafeDestroy(Object target)
    {
        if (target == null)
            return;

        if (Application.isPlaying)
            Destroy(target);
        else
            DestroyImmediate(target);
    }

    void EnsureRendererMaterial(Renderer renderer)
    {
        if (renderer == null)
            return;

        if (Application.isPlaying)
        {
            var runtimeMaterial = renderer.material;
            if (runtimeMaterial != null)
                runtimeMaterial.color = runtimeMaterial.color;
            return;
        }

        if (renderer.sharedMaterial == null)
            return;

        renderer.sharedMaterial = new Material(renderer.sharedMaterial);
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
