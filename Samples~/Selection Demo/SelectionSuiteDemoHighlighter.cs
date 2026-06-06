using JorisHoef.ObjectSelection;
using UnityEngine;
using Object = UnityEngine.Object;

namespace JorisHoef.SelectionSuite.Samples.SelectionDemo
{
    public sealed class SelectionSuiteDemoHighlighter : MonoBehaviour, IObjectSelectionVisual<string>
    {
        [SerializeField] private Color selectedColor = new Color(1f, 0.72f, 0.18f, 1f);
        [SerializeField] private float selectedScale = 1.12f;

        private MaterialPropertyBlock _propertyBlock;
        private Transform _scaledTransform;
        private Vector3 _originalScale;

        public void ApplySelected(string key, Object target)
        {
            GameObject targetGameObject = ResolveGameObject(target);
            if (targetGameObject == null)
            {
                return;
            }

            ApplyTint(targetGameObject);
            ApplyScale(targetGameObject);
        }

        public void ApplyDeselected(string key, Object target)
        {
            GameObject targetGameObject = ResolveGameObject(target);
            if (targetGameObject == null)
            {
                return;
            }

            Renderer renderer = targetGameObject.GetComponent<Renderer>();
            if (renderer != null)
            {
                renderer.SetPropertyBlock(null);
            }

            if (_scaledTransform == targetGameObject.transform)
            {
                _scaledTransform.localScale = _originalScale;
                _scaledTransform = null;
            }
        }

        private void ApplyTint(GameObject targetGameObject)
        {
            Renderer renderer = targetGameObject.GetComponent<Renderer>();
            if (renderer == null)
            {
                return;
            }

            if (_propertyBlock == null)
            {
                _propertyBlock = new MaterialPropertyBlock();
            }

            renderer.GetPropertyBlock(_propertyBlock);
            _propertyBlock.SetColor("_Color", selectedColor);
            _propertyBlock.SetColor("_BaseColor", selectedColor);
            renderer.SetPropertyBlock(_propertyBlock);
        }

        private void ApplyScale(GameObject targetGameObject)
        {
            if (_scaledTransform == targetGameObject.transform)
            {
                return;
            }

            _scaledTransform = targetGameObject.transform;
            _originalScale = _scaledTransform.localScale;
            _scaledTransform.localScale = _originalScale * selectedScale;
        }

        private static GameObject ResolveGameObject(Object unityObject)
        {
            if (unityObject == null)
            {
                return null;
            }

            GameObject gameObject = unityObject as GameObject;
            if (gameObject != null)
            {
                return gameObject;
            }

            Component component = unityObject as Component;
            return component != null ? component.gameObject : null;
        }
    }
}
