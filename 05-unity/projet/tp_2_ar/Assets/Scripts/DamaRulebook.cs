using System.Collections.Generic;

public static class DamaRulebook
{
    public static List<DamaMoveSuggestion> GetLegalMoves(DamaBoardSnapshot snapshot, DamaSide side)
    {
        var captureMoves = new List<DamaMoveSuggestion>();
        var normalMoves = new List<DamaMoveSuggestion>();

        for (int row = 0; row < 8; row++)
        {
            for (int col = 0; col < 8; col++)
            {
                var from = new DamaCoordinate(row, col);
                if (!snapshot.HasPiece(from))
                    continue;

                var piece = snapshot.GetPiece(from);
                if (piece.Side != side)
                    continue;

                AppendMovesForPiece(snapshot, from, piece, normalMoves, captureMoves);
            }
        }

        return captureMoves.Count > 0 ? captureMoves : normalMoves;
    }

    public static List<DamaMoveSuggestion> GetContinuationCaptures(DamaBoardSnapshot snapshot, DamaCoordinate from)
    {
        var results = new List<DamaMoveSuggestion>();
        if (!snapshot.HasPiece(from))
            return results;

        var piece = snapshot.GetPiece(from);
        AppendMovesForPiece(snapshot, from, piece, null, results);
        return results;
    }

    static void AppendMovesForPiece(
        DamaBoardSnapshot snapshot,
        DamaCoordinate from,
        DamaPieceState piece,
        List<DamaMoveSuggestion> normalMoves,
        List<DamaMoveSuggestion> captureMoves)
    {
        foreach (var direction in GetDirections(piece))
        {
            int nextRow = from.Row + direction.Row;
            int nextCol = from.Col + direction.Col;
            var next = new DamaCoordinate(nextRow, nextCol);

            if (!next.IsValid)
                continue;

            if (!snapshot.HasPiece(next))
            {
                if (normalMoves != null)
                {
                    normalMoves.Add(new DamaMoveSuggestion
                    {
                        From = from,
                        To = next,
                        IsCapture = false,
                        HasCapturedPiece = false
                    });
                }

                continue;
            }

            var blockingPiece = snapshot.GetPiece(next);
            if (blockingPiece.Side == piece.Side)
                continue;

            var landing = new DamaCoordinate(nextRow + direction.Row, nextCol + direction.Col);
            if (!landing.IsValid || snapshot.HasPiece(landing))
                continue;

            captureMoves.Add(new DamaMoveSuggestion
            {
                From = from,
                To = landing,
                IsCapture = true,
                HasCapturedPiece = true,
                Captured = next
            });
        }
    }

    static IEnumerable<DamaCoordinate> GetDirections(DamaPieceState piece)
    {
        if (piece.IsKing)
        {
            yield return new DamaCoordinate(-1, -1);
            yield return new DamaCoordinate(-1, 1);
            yield return new DamaCoordinate(1, -1);
            yield return new DamaCoordinate(1, 1);
            yield break;
        }

        int rowStep = piece.Side == DamaSide.PlayerOne ? -1 : 1;
        yield return new DamaCoordinate(rowStep, -1);
        yield return new DamaCoordinate(rowStep, 1);
    }
}
