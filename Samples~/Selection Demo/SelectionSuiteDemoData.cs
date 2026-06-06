using JorisHoef.Core.State;

namespace JorisHoef.SelectionSuite.Samples.SelectionDemo
{
    public sealed class SelectionSuiteDemoData : IIdentifiable<string>
    {
        public SelectionSuiteDemoData(string id, string label)
        {
            Id = id;
            Label = label;
        }

        public string Id { get; }

        public string Label { get; }
    }
}
