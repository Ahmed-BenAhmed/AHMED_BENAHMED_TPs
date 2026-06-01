using System;

public enum DamaSide
{
    PlayerOne,
    PlayerTwo
}

public enum DamaSquareVisualState
{
    Default,
    Selected,
    LegalTarget,
    HintSource,
    HintTarget
}

public struct DamaCoordinate : IEquatable<DamaCoordinate>
{
    public int Row { get; }
    public int Col { get; }

    public DamaCoordinate(int row, int col)
    {
        Row = row;
        Col = col;
    }

    public bool IsValid => Row >= 0 && Row < 8 && Col >= 0 && Col < 8;

    public string ToNotation()
    {
        char file = (char)('A' + Col);
        int rank = 8 - Row;
        return string.Concat(file, rank.ToString());
    }

    public bool Equals(DamaCoordinate other)
    {
        return Row == other.Row && Col == other.Col;
    }

    public override bool Equals(object obj)
    {
        return obj is DamaCoordinate other && Equals(other);
    }

    public override int GetHashCode()
    {
        unchecked
        {
            return (Row * 397) ^ Col;
        }
    }

    public override string ToString()
    {
        return ToNotation();
    }

    public static bool operator ==(DamaCoordinate left, DamaCoordinate right)
    {
        return left.Equals(right);
    }

    public static bool operator !=(DamaCoordinate left, DamaCoordinate right)
    {
        return !left.Equals(right);
    }
}
