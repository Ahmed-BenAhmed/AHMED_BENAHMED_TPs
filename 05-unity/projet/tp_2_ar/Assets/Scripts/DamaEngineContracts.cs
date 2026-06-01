public struct DamaPieceState
{
    public bool IsOccupied;
    public DamaSide Side;
    public bool IsKing;
}

public struct DamaMoveSuggestion
{
    public DamaCoordinate From;
    public DamaCoordinate To;
    public bool IsCapture;
    public bool HasCapturedPiece;
    public DamaCoordinate Captured;

    public string ToShortString()
    {
        string separator = IsCapture ? " x " : " -> ";
        return From.ToNotation() + separator + To.ToNotation();
    }
}

public class DamaBoardSnapshot
{
    public DamaPieceState[,] Cells { get; } = new DamaPieceState[8, 8];
    public DamaSide SideToMove { get; set; }

    public bool HasPiece(DamaCoordinate coordinate)
    {
        return coordinate.IsValid && Cells[coordinate.Row, coordinate.Col].IsOccupied;
    }

    public DamaPieceState GetPiece(DamaCoordinate coordinate)
    {
        return Cells[coordinate.Row, coordinate.Col];
    }
}

public interface IDamaAnalysisEngine
{
    bool TrySuggestMove(DamaBoardSnapshot snapshot, out DamaMoveSuggestion suggestion);
}
