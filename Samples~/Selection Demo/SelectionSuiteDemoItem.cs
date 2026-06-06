using JorisHoef.GenericUIItems;
using UnityEngine;
using UnityEngine.UI;

namespace JorisHoef.SelectionSuite.Samples.SelectionDemo
{
    public sealed class SelectionSuiteDemoItem : GenericItem<SelectionSuiteDemoData>
    {
        [SerializeField] private SelectionSuiteDemo owner;
        [SerializeField] private Text label;
        [SerializeField] private Button button;

        private void Awake()
        {
            EnsureReferences();
            WireButton();
        }

        private void OnDestroy()
        {
            if (button != null)
            {
                button.onClick.RemoveListener(OnClicked);
            }
        }

        public void Configure(
            SelectionSuiteDemo demoOwner,
            Text itemLabel,
            Button itemButton)
        {
            owner = demoOwner;

            if (itemLabel != null)
            {
                label = itemLabel;
            }

            if (itemButton != null)
            {
                button = itemButton;
            }
        }

        public override void SetData(SelectionSuiteDemoData data)
        {
            base.SetData(data);
            EnsureReferences();

            if (label != null)
            {
                label.text = data != null ? data.Label + " (" + data.Id + ")" : string.Empty;
            }
        }

        private void OnClicked()
        {
            if (owner != null && Data != null)
            {
                owner.SelectFromUi(Data.Id);
            }
        }

        private void EnsureReferences()
        {
            if (button == null)
            {
                button = GetComponent<Button>();
            }

            if (label == null)
            {
                label = GetComponentInChildren<Text>();
            }
        }

        private void WireButton()
        {
            if (button == null)
            {
                return;
            }

            button.onClick.RemoveListener(OnClicked);
            button.onClick.AddListener(OnClicked);
        }
    }
}
