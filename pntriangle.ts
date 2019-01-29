let p1: ISamplePoint = {
    p: [0, 0, 0],
    n: [-1, -1, 0]
};
let p2: ISamplePoint = {
    p: [1, 0, 0],
    n: [1, -1, 0]
};
let p3: ISamplePoint = {
    p: [1, 1, 0],
    n: [1, 1, 0]
};
let p4: ISamplePoint = {
    p: [0, 1, 0],
    n: [-1, 1, 0]
};
let points1 = PNTriangles(p1, p2, p3);
let points2 = PNTriangles(p1, p3, p4);
let points = [];
Array.prototype.push.apply(points, [p1, points1[0], points1[2]]);
Array.prototype.push.apply(points, [points1[0], p2, points1[2]]);
Array.prototype.push.apply(points, [p2, points1[1], points1[2]]);
Array.prototype.push.apply(points, [points1[2], points1[1], p3]);
Array.prototype.push.apply(points, [points1[2], p3, points2[1]]);
Array.prototype.push.apply(points, [points1[2], points2[1], p4]);
Array.prototype.push.apply(points, [points1[2], p4, points2[2]]);
Array.prototype.push.apply(points, [points1[2], points2[2], p1]);
let file_str: string = '';
for (let i = 0, num = points.length / 3; i < num; ++i) {
}
// let workRoot = join(WORK_ROOT_PATH, pid, MODEL_DIR);
// await writeFile(join(workRoot, 'tris.json'), JSON.stringify(points))
//     .catch(console.log);

interface ISamplePoint {
    p: number[];
    n: number[];
}

function PNTriangles(p1: ISamplePoint, p2: ISamplePoint, p3: ISamplePoint): ISamplePoint[] {
    const b_300: number[] = p1.p;
    const b_030: number[] = p2.p;
    const b_003: number[] = p3.p;

    const b_210: number[] = GetBij(p1, p2);
    const b_120: number[] = GetBij(p2, p1);
    const b_021: number[] = GetBij(p2, p3);
    const b_012: number[] = GetBij(p3, p2);
    const b_102: number[] = GetBij(p3, p1);
    const b_201: number[] = GetBij(p1, p3);

    let E: number[] = [];
    let V: number[] = [];
    let b_111: number[] = [];
    for (let i = 0; i < 3; ++i) {
        E.push((b_210[i] + b_120[i] + b_021[i] + b_012[i] + b_102[i] + b_201[i]) / 6);
        V.push(p1.p[i] + p2.p[i] + p3.p[i]) / 3;

        b_111.push((3 * E[i] - V[i]) / 2);
    }

    const n_200: number[] = p1.n;
    const n_020: number[] = p2.n;
    const n_002: number[] = p3.n;

    const n_110: number[] = GetNij(p1, p2);
    const n_011: number[] = GetNij(p2, p3);
    const n_101: number[] = GetNij(p3, p1);

    let p_mid21: ISamplePoint = {
        p: [
            (p1.p[0] + p2.p[0]) / 2,
            (p1.p[1] + p2.p[1]) / 2,
            (p1.p[2] + p2.p[2]) / 2
        ],
        n: [0,0,0]
    };
    let p_mid32: ISamplePoint = {
        p: [
            (p2.p[0] + p3.p[0]) / 2,
            (p2.p[1] + p3.p[1]) / 2,
            (p2.p[2] + p3.p[2]) / 2
        ],
        n: [0,0,0]
    };
    let p_mid13: ISamplePoint = {
        p: [
            (p3.p[0] + p1.p[0]) / 2,
            (p3.p[1] + p1.p[1]) / 2,
            (p3.p[2] + p1.p[2]) / 2
        ],
        n: [0,0,0]
    };
    let uv_mid21: number[] = GetUV4PNTri(p1, p2, p3, p_mid21);
    let uv_mid32: number[] = GetUV4PNTri(p1, p2, p3, p_mid32);
    let uv_mid13: number[] = GetUV4PNTri(p1, p2, p3, p_mid13);

    let xyz_mid21: ISamplePoint = GetPoint(
        b_300, b_030, b_003,
        b_210, b_120, b_021, b_012, b_102, b_201,
        b_111,
        n_200, n_020, n_002,
        n_110, n_011, n_101,
        uv_mid21[0], uv_mid21[1]
    );

    let xyz_mid32: ISamplePoint = GetPoint(
        b_300, b_030, b_003,
        b_210, b_120, b_021, b_012, b_102, b_201,
        b_111,
        n_200, n_020, n_002,
        n_110, n_011, n_101,
        uv_mid32[0], uv_mid32[1]
    );

    let xyz_mid13: ISamplePoint = GetPoint(
        b_300, b_030, b_003,
        b_210, b_120, b_021, b_012, b_102, b_201,
        b_111,
        n_200, n_020, n_002,
        n_110, n_011, n_101,
        uv_mid13[0], uv_mid13[1]
    );

    return [
        xyz_mid21, xyz_mid32, xyz_mid13
    ]
}

function GetWij(pi: ISamplePoint, pj: ISamplePoint): number {
    let wij: number = 0;
    for (let i = 0; i < 3; ++i) {
        wij += (pj.p[i] - pi.p[i]) * pi.n[i];
    }
    return wij;
}

function GetVij(pi: ISamplePoint, pj: ISamplePoint): number {
    let vij: number = 0;
    let k: number = 0;
    for (let i = 0; i < 3; ++i) {
        vij += (pj.p[i] - pi.p[i]) * (pj.n[i] + pi.n[i]);
        k += (pj.p[i] - pi.p[i]) * (pj.p[i] - pi.p[i]);
    }

    vij = 2 * vij / k;
    return vij;
}

function GetBij(pi: ISamplePoint, pj: ISamplePoint): number[] {
    let bij: number[] = [];
    const wij: number = GetWij(pi, pj);
    for (let i = 0; i < 3; ++i) {
        bij.push((2 * pi.p[i] + pj.p[i] - wij * pi.n[i]) / 3);
    }
    return bij;
}

function GetNij(pi: ISamplePoint, pj: ISamplePoint): number[] {
    let nij: number[] = [];
    const vij: number = GetVij(pi, pj);
    let k: number = 0;
    for (let i = 0; i < 3; ++i) {
        nij.push(pi.n[i] + pj.n[i] - vij * (pj.p[i] - pi.p[i]));
        k += Math.pow(nij[i], 2);
    }
    k = Math.pow(k, 0.5);
    for (let i = 0; i < 3; ++i) {
        nij[i] /= k;
    }

    return nij;
}

function GetUV4PNTri(p1: ISamplePoint, p2: ISamplePoint, p3: ISamplePoint, p: ISamplePoint): number[] {
    let vector_21: number[] = [];
    let vector_32: number[] = [];
    let vector_13: number[] = [];
    let vector_pp1: number[] = [];
    let vector_pp2: number[] = [];
    let vector_pp3: number[] = [];

    for (let i = 0; i < 3; ++i) {
        vector_21.push(p2.p[i] - p1.p[i]);
        vector_32.push(p3.p[i] - p2.p[i]);
        vector_13.push(p1.p[i] - p3.p[i]);

        vector_pp1.push(p.p[i] - p1.p[i]);
        vector_pp2.push(p.p[i] - p2.p[i]);
        vector_pp3.push(p.p[i] - p3.p[i]);
    }

    let pp1p2: number[] = [
        vector_21[1] * vector_pp1[2] - vector_21[2] * vector_pp1[1],
        vector_21[2] * vector_pp1[0] - vector_21[0] * vector_pp1[2],
        vector_21[0] * vector_pp1[1] - vector_21[1] * vector_pp1[0]
    ];
    let pp2p3: number[] = [
        vector_32[1] * vector_pp2[2] - vector_32[2] * vector_pp2[1],
        vector_32[2] * vector_pp2[0] - vector_32[0] * vector_pp2[2],
        vector_32[0] * vector_pp2[1] - vector_32[1] * vector_pp2[0]
    ];
    let pp3p1: number[] = [
        vector_13[1] * vector_pp3[2] - vector_13[2] * vector_pp3[1],
        vector_13[2] * vector_pp3[0] - vector_13[0] * vector_pp3[2],
        vector_13[0] * vector_pp3[1] - vector_13[1] * vector_pp3[0]
    ];

    let s_pp1p2: number = 0.0;
    let s_pp2p3: number = 0.0;
    let s_pp3p1: number = 0.0;
    for (let i = 0; i < 3; ++i) {
        s_pp1p2 += Math.pow(pp1p2[i], 2);
        s_pp2p3 += Math.pow(pp2p3[i], 2);
        s_pp3p1 += Math.pow(pp3p1[i], 2);
    }
    let s_sum: number = s_pp1p2 + s_pp2p3 + s_pp3p1;
    let u: number = s_pp2p3 / s_sum;
    let v: number = s_pp3p1 / s_sum;
    return [u, v];
}

function GetPoint(
    b_300: number[], b_030: number[], b_003: number[],
    b_210: number[], b_120: number[], b_021: number[], b_012: number[], b_102: number[], b_201: number[],
    b_111: number[],
    n_200: number[], n_020: number[], n_002: number[],
    n_110: number[], n_011: number[], n_101: number[],
    u: number, v: number): ISamplePoint {

    const w: number = 1 - u - v;
    const w2: number = Math.pow(w, 2);
    const w3: number = w2 * w;
    const w2u: number = w2 * u;
    const w2v: number = w2 * v;
    const wu: number = w * u;
    const wv: number = w * v;
    const u2: number = Math.pow(u, 2);
    const u3: number = u2 * u;
    const u2w: number = u2 * w;
    const u2v: number = u2 * v;
    const uv: number = u * v;
    const v2: number = Math.pow(v, 2);
    const v3: number = v2 * v;
    const v2w: number = v2 * w;
    const v2u: number = v2 * u;
    const uvw: number = u * v * w;

    let p: number[] = [];
    let n: number[] = [];
    let temp: number = 0;
    for (let i = 0; i < 3; ++i) {
        temp = b_300[i] * w3 + b_030[i] * u3 + b_003[i] * v3 
        + b_210[i] * 3 * w2u + b_120[i] * 3 * u2w + b_201[i] * 3 * w2v
        + b_021[i] * 3 * u2v + b_102[i] * 3 * v2w + b_012[i] * 3 * v2u
        + b_111[i] * 6 * uvw;
        p.push(temp);
        temp = n_200[i] * w2 + n_020[i] * u2 + n_002[i] * v2
        + n_110[i] * wu + n_011[i] * uv + n_101[i] * wv;
        n.push(temp);
    }
    return {
        p,
        n
    };
}