using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;


[ExecuteAlways]
public class RenderQuad : MonoBehaviour
{
   
   public Material mat;
    public int size;


MaterialPropertyBlock  mpb;
    void OnEnable(){
        mpb = new MaterialPropertyBlock();
    }

    // Update is called once per frame
    void Update()
    {

        mpb.SetInt( "_Size" , size );
       Graphics.DrawProcedural(mat, new Bounds( Vector3.zero, Vector3.one * 100000), MeshTopology.Triangles, (size -1) * (size-1) *3  * 2, 1,null , mpb,ShadowCastingMode.On, true);
 
    }
}
