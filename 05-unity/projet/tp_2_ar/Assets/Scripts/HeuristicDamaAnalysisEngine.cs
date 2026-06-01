using System.Collections.Generic;

public class HeuristicDamaAnalysisEngine : IDamaAnalysisEngine
{
    public bool TrySuggestMove(DamaBoardSnapshot snapshot, out DamaMoveSuggestion suggestion)
    {
        var legalMoves = DamaRulebook.GetLegalMoves(snapshot, snapshot.SideToMove);
        if (legalMoves.Count == 0)
        {
            suggestion = default;
            return false;
        }

        suggestion = ChooseBestMove(snapshot, legalMoves);
        return true;
    }

    DamaMoveSuggestion ChooseBestMove(DamaBoardSnapshot snapshot, List<DamaMoveSuggestion> legalMoves)
    {
        DamaMoveSuggestion bestMove = legalMoves[0];
        int bestScore = ScoreMove(snapshot, bestMove);

        for (int i = 1; i < legalMoves.Count; i++)
        {
            int score = ScoreMove(snapshot, legalMoves[i]);
            if (score > bestScore)
            {
                bestScore = score;
                bestMove = legalMoves[i];
            }
        }

        return bestMove;
    }

    int ScoreMove(DamaBoardSnapshot snapshot, DamaMoveSuggestion move)
    {
        int score = 0;
        if (move.IsCapture)
            score += 100;

        int centerDistance = System.Math.Abs(move.To.Row - 3) + System.Math.Abs(move.To.Col - 3);
        score += 10 - centerDistance;

        var movingPiece = snapshot.GetPiece(move.From);
        bool promotes = !movingPiece.IsKing &&
                        ((movingPiece.Side == DamaSide.PlayerOne && move.To.Row == 0) ||
                         (movingPiece.Side == DamaSide.PlayerTwo && move.To.Row == 7));
        if (promotes)
            score += 50;

        return score;
    }
}
