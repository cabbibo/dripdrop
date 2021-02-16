Shader "Unlit/DripDrop"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        Cull off
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"


            int _Size;
           
           
            struct v2f{
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

    
    
    float hash( float n ){
        return frac(sin(n)*43758.5453);
      }

            v2f vert ( uint id : SV_VertexID )
            {
                v2f o;
                int quadID = id /6;
                int inQuadID = id % 6;


                int row = quadID / (_Size-1);
                int col = quadID % (_Size-1);

                float meltVal = (_Time.y/4)%1;


                float3 curvePoint = float3(-1,0,0);

                float angle = ((meltVal*(.1+ float(row)/(_Size-1))) + .5) *2* 3.14159 ;
                float angleU = ((meltVal*(.1+ float(row+1)/(_Size-1)))+.5)*2* 3.14159 ;


                float3 x = float3(1,0,0);
                float3 y = float3(0,1,0);

                
                float3 newX = lerp( x, sin(angle) * x - cos(angle)*y,meltVal);
                float3 newY = lerp( y, normalize(cross(newX,float3(0,0,1))),meltVal);

                float3 newXU = lerp( x,sin(angleU) * x - cos(angleU)*y,meltVal);
                float3 newYU = lerp( y,normalize(cross(newXU,float3(0,0,1))),meltVal);









                float r = (float(row) / float(_Size-1)) - .5;
                float c = (float(col) / float(_Size-1)) - .5;


                float rU = (float(row+1) / float(_Size-1)) - .5;
                float cU = (float(col+1) / float(_Size-1)) - .5;

                float3 p1 = 3 * c * newX + r * newY;
                float3 p2 = 3 * cU * newX + r * newY;
                float3 p3 = 3 *  c * newXU  + rU * newYU;
                float3 p4 = 3 * cU * newXU  + rU * newYU;


                float2 uv1 = float2(float(row)   , float(col))/float(_Size);
                float2 uv2 = float2(float(row)   , float(col+1))/float(_Size);
                float2 uv3 = float2(float(row+1) , float(col))/float(_Size);
                float2 uv4 = float2(float(row+1) , float(col+1))/float(_Size);

                float3 fPos;
                float2 fUV;


                float radius = 2;

                if( inQuadID  == 0 || inQuadID == 3 ){
                    fPos = p1;
                    fUV = uv1;
                    fPos += radius * newX;
                }else if( inQuadID == 1){
                    fPos = p2;
                    fUV = uv2;
                    fPos += radius * newX;
                }else if( inQuadID == 2 || inQuadID == 4 ){
                    fPos = p4;
                    fUV = uv4;
                    fPos += radius * newXU;
                }else{
                    fPos = p3;
                    fUV = uv3;
                    fPos += radius * newXU;
                }

                fUV = fUV.yx;    
                o.uv = fUV;

            

                o.vertex = UnityObjectToClipPos(float4(fPos,1));
                
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col =  tex2D(_MainTex , i.uv);
                return col;
            }
            ENDCG
        }
    }
}
