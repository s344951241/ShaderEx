using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CSharpTest : MonoBehaviour {

	// Use this for initialization
	void Start () {
        Camera.main.SetReplacementShader(Shader.Find("Unlit/HalfDiffuse"), "RenderType");
	}
	
	// Update is called once per frame
	void Update () {
		
	}
}
