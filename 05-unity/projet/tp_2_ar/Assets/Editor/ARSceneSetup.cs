// ARSceneSetup.cs
// Automatically rebuilds BlankAR.unity for AR Foundation 6 / Unity 6.
// AR Foundation 6 replaced ARSessionOrigin with XROrigin (Unity.XR.CoreUtils).
// Run manually: Tools > Rebuild AR Scene (Unity 6)
// Also runs once automatically on first project open.

#if UNITY_EDITOR
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.XR.ARFoundation;
using Unity.XR.CoreUtils;
using UnityEngine.InputSystem.XR;

[InitializeOnLoad]
public static class ARSceneSetup
{
    const string ScenePath = "Assets/Scenes/BlankAR.unity";
    const string SetupDoneKey = "ARScene_Unity6_SetupComplete";

    static ARSceneSetup()
    {
        // Run once per editor session after all scripts compile
        if (SessionState.GetBool(SetupDoneKey, false))
            return;

        EditorApplication.delayCall += () =>
        {
            // Only auto-run if the scene still has ARSessionOrigin (old setup)
            // or if scene GameObjects look like the old structure
            if (SceneNeedsRebuild())
            {
                Debug.Log("[AR Scene Setup] Old AR Foundation 4 scene detected. Rebuilding for AR Foundation 6...");
                BuildARScene();
                SessionState.SetBool(SetupDoneKey, true);
            }
            else
            {
                SessionState.SetBool(SetupDoneKey, true);
            }
        };
    }

    [MenuItem("Tools/Rebuild AR Scene (Unity 6)")]
    public static void RebuildARScene()
    {
        BuildARScene();
    }

    static bool SceneNeedsRebuild()
    {
        // Check if any XROrigin already exists in the scene
        return Object.FindFirstObjectByType<XROrigin>() == null;
    }

    static void BuildARScene()
    {
        // Load or create the scene
        var scene = EditorSceneManager.OpenScene(ScenePath, OpenSceneMode.Single);

        // Clear all existing root GameObjects
        foreach (var go in scene.GetRootGameObjects())
            Object.DestroyImmediate(go);

        // --- 1. Directional Light ---
        var lightGO = new GameObject("Directional Light");
        var light = lightGO.AddComponent<Light>();
        light.type = LightType.Directional;
        light.intensity = 1f;
        light.color = new Color(1f, 0.956f, 0.839f);
        light.shadows = LightShadows.Soft;
        lightGO.transform.rotation = Quaternion.Euler(50f, -30f, 0f);
        lightGO.transform.position = new Vector3(0f, 3f, 0f);

        // --- 2. AR Session ---
        var arSessionGO = new GameObject("AR Session");
        arSessionGO.AddComponent<ARSession>();

        // --- 3. XR Origin (replaces ARSessionOrigin from AR Foundation 4) ---
        var xrOriginGO = new GameObject("XR Origin");
        var xrOrigin = xrOriginGO.AddComponent<XROrigin>();
        xrOriginGO.AddComponent<ARPlaneManager>();
        xrOriginGO.AddComponent<ARAnchorManager>();
        xrOriginGO.AddComponent<ARRaycastManager>();
        xrOriginGO.AddComponent<DamaBoardPlacement>();

        // --- 4. Camera Offset (child of XR Origin) ---
        var cameraOffsetGO = new GameObject("Camera Offset");
        cameraOffsetGO.transform.SetParent(xrOriginGO.transform, false);
        xrOrigin.CameraFloorOffsetObject = cameraOffsetGO;

        // --- 5. AR Camera (child of Camera Offset) ---
        var arCameraGO = new GameObject("AR Camera");
        arCameraGO.transform.SetParent(cameraOffsetGO.transform, false);
        arCameraGO.tag = "MainCamera";

        var cam = arCameraGO.AddComponent<Camera>();
        cam.clearFlags = CameraClearFlags.Color;
        cam.backgroundColor = Color.black;
        cam.nearClipPlane = 0.1f;
        cam.farClipPlane = 20f;

        arCameraGO.AddComponent<ARCameraManager>();
        arCameraGO.AddComponent<ARCameraBackground>();

        // TrackedPoseDriver — drives camera pose from AR subsystem (Input System package)
        var tpd = arCameraGO.AddComponent<TrackedPoseDriver>();
        tpd.positionAction = new UnityEngine.InputSystem.InputAction(
            binding: "<XRHMD>/centerEyePosition",
            expectedControlType: "Vector3");
        tpd.rotationAction = new UnityEngine.InputSystem.InputAction(
            binding: "<XRHMD>/centerEyeRotation",
            expectedControlType: "Quaternion");

        // Link camera to XR Origin
        xrOrigin.Camera = cam;

        // Save the scene
        EditorSceneManager.SaveScene(scene, ScenePath);
        AssetDatabase.Refresh();

        Debug.Log("[AR Scene Setup] Done! Scene rebuilt with XROrigin + ARCameraManager for AR Foundation 6.");
        EditorUtility.DisplayDialog(
            "AR Scene Setup Complete",
            "BlankAR.unity has been rebuilt for AR Foundation 6 / Unity 6.\n\n" +
            "Scene structure:\n" +
            "  • AR Session\n" +
            "  • XR Origin (+ ARPlaneManager, ARAnchorManager, ARRaycastManager, DamaBoardPlacement)\n" +
            "    └─ Camera Offset\n" +
            "       └─ AR Camera (+ ARCameraManager, ARCameraBackground, TrackedPoseDriver)\n\n" +
            "Hit Play to test on desktop (fallback mode), or build for Android/iOS.",
            "OK");
    }
}
#endif
