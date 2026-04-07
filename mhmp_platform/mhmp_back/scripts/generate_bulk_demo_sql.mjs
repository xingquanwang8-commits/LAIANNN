import fs from 'node:fs';
import path from 'node:path';

const rootDir = path.resolve('d:/Vue_Workspace/mhmp_platform/mhmp_back');
const outputDir = path.join(rootDir, 'scripts', 'generated');
const outputFile = path.join(outputDir, 'bulk_demo_seed_20260408.sql');

const now = new Date('2026-04-08T10:00:00+08:00');
const imageUrl = '/uploads/demo/images/relic-placeholder.png';
const reportUrl = '/uploads/demo/reports/appraisal-note.txt';
const docUrl = '/uploads/demo/reports/archive-note.txt';
const repairFileUrl = '/uploads/demo/repair/repair-log-note.txt';

const fallbackHashes = {
  admin: '$2y$10$CHHfXNbJcqtXHp32oZjtVuRzV33SygS0Fk2WAENwh3oma0vlfW5om',
  researcher: '$2y$10$3zq.H2DXJWc5OwLT7wApWeXx2zaWizO3M/49Bt5eHgGF8RSnsjIv.',
  docent: '$2y$10$MjM/t.BlshSizvSU2lq48OkA1y/1IFnZP2HPBGjnh7bB2MN3LieQ6'
};

let seed = 20260408;
const rand = () => ((seed = (seed * 1664525 + 1013904223) % 4294967296) / 4294967296);
const pick = (items) => items[Math.floor(rand() * items.length)];
const pad = (value, size) => String(value).padStart(size, '0');
const sql = (value) => value == null ? 'NULL' : `'${String(value).replace(/\\/g, '\\\\').replace(/'/g, "''").replace(/\r?\n/g, ' ')}'`;
const dt = (value) => sql(value instanceof Date ? fmt(value) : value);
const fmt = (date) => {
  const p = (n) => String(n).padStart(2, '0');
  return `${date.getFullYear()}-${p(date.getMonth() + 1)}-${p(date.getDate())} ${p(date.getHours())}:${p(date.getMinutes())}:${p(date.getSeconds())}`;
};
const daysAgo = (days, hour = 10, minute = 0) => {
  const date = new Date(now);
  date.setDate(date.getDate() - days);
  date.setHours(hour, minute, 0, 0);
  return date;
};
const chunk = (items, size) => Array.from({ length: Math.ceil(items.length / size) }, (_, i) => items.slice(i * size, (i + 1) * size));
const lines = [];
const pushSql = (statement) => lines.push(statement.trim(), '');

const users = [
  ['admin02', '馆务平台主管', '赵楠', '女', 'admin', '13988020001', 'admin02@mhmp.local', '分管馆务统筹与跨部门协同。'],
  ['admin03', '藏品安全主管', '陈昊', '男', 'admin', '13988020002', 'admin03@mhmp.local', '分管安全巡检、库房调度与外借审核。'],
  ['admin04', '系统运维主管', '许薇', '女', 'admin', '13988020003', 'admin04@mhmp.local', '负责系统巡检、账号协同与异常处理。'],
  ['admin05', '业务协同主管', '刘舟', '男', 'admin', '13988020004', 'admin05@mhmp.local', '负责流程复核、馆际交流与台账抽查。'],
  ['researcher02', '青铜研究员', '王蕾', '女', 'researcher', '13988030001', 'researcher02@mhmp.local', '负责青铜器建档与病害研判。'],
  ['researcher03', '陶瓷研究员', '周洋', '男', 'researcher', '13988030002', 'researcher03@mhmp.local', '负责陶瓷器分类与外借复核。'],
  ['researcher04', '书画研究员', '林清', '女', 'researcher', '13988030003', 'researcher04@mhmp.local', '负责书画类文物建档与修复申请。'],
  ['researcher05', '玉器研究员', '何远', '男', 'researcher', '13988030004', 'researcher05@mhmp.local', '负责玉器状态评估与调拨复核。'],
  ['researcher06', '金银器研究员', '苏瑶', '女', 'researcher', '13988030005', 'researcher06@mhmp.local', '负责金银器病害观察与展陈准备。'],
  ['researcher07', '木器研究员', '郑川', '男', 'researcher', '13988030006', 'researcher07@mhmp.local', '负责木器与竹木器类建档复核。'],
  ['researcher08', '漆器研究员', '宋宁', '女', 'researcher', '13988030007', 'researcher08@mhmp.local', '负责漆器病害复核与修复跟踪。'],
  ['researcher09', '石刻研究员', '魏安', '男', 'researcher', '13988030008', 'researcher09@mhmp.local', '负责石刻与造像类文物台账整理。'],
  ['researcher10', '保管研究员', '唐蕾', '女', 'researcher', '13988030009', 'researcher10@mhmp.local', '负责库位复核与盘点任务执行。'],
  ['researcher11', '修复研究员', '韩卓', '男', 'researcher', '13988030010', 'researcher11@mhmp.local', '负责修复方案编制与工序记录。'],
  ['researcher12', '陈列研究员', '顾琳', '女', 'researcher', '13988030011', 'researcher12@mhmp.local', '负责展陈借展与回库复核。'],
  ['researcher13', '档案研究员', '罗宁', '男', 'researcher', '13988030012', 'researcher13@mhmp.local', '负责档案补录与附件整理。'],
  ['researcher14', '馆藏研究员', '姚菲', '女', 'researcher', '13988030013', 'researcher14@mhmp.local', '负责综合建档与业务联调。'],
  ['docent02', '资深讲解员', '王倩', '女', 'docent', '13988040001', 'docent02@mhmp.local', '负责固定陈列讲解与公众咨询。'],
  ['docent03', '展厅讲解员', '沈越', '男', 'docent', '13988040002', 'docent03@mhmp.local', '负责青铜与陶瓷展区讲解。'],
  ['docent04', '社教专员', '夏妍', '女', 'docent', '13988040003', 'docent04@mhmp.local', '负责公众教育与活动协助。'],
  ['docent05', '临展讲解员', '蒋晨', '男', 'docent', '13988040004', 'docent05@mhmp.local', '负责临展接待与借展辅助。'],
  ['docent06', '讲解助理', '傅泽', '男', 'docent', '13988040005', 'docent06@mhmp.local', '负责讲解排班与参观导引。'],
  ['docent07', '公众服务专员', '梁悦', '女', 'docent', '13988040006', 'docent07@mhmp.local', '负责展厅秩序与观众问询。'],
  ['docent08', '展陈讲解员', '高杉', '男', 'docent', '13988040007', 'docent08@mhmp.local', '负责专题展讲解与观众接待。'],
  ['docent09', '社教讲解员', '袁青', '女', 'docent', '13988040008', 'docent09@mhmp.local', '负责馆校合作讲解服务。']
].map(([username, nickName, realName, gender, roleCode, phone, email, remark]) => ({ username, nickName, realName, gender, roleCode, phone, email, remark }));

const researchers = ['researcher', ...users.filter((item) => item.roleCode === 'researcher').map((item) => item.username)];
const admins = ['admin', ...users.filter((item) => item.roleCode === 'admin').map((item) => item.username)];
const nameMap = {
  admin: '管理员',
  researcher: '李博',
  docent: '王悦',
  admin02: '赵楠', admin03: '陈昊', admin04: '许薇', admin05: '刘舟',
  researcher02: '王蕾', researcher03: '周洋', researcher04: '林清', researcher05: '何远',
  researcher06: '苏瑶', researcher07: '郑川', researcher08: '宋宁', researcher09: '魏安',
  researcher10: '唐蕾', researcher11: '韩卓', researcher12: '顾琳', researcher13: '罗宁', researcher14: '姚菲',
  docent02: '王倩', docent03: '沈越', docent04: '夏妍', docent05: '蒋晨', docent06: '傅泽', docent07: '梁悦', docent08: '高杉', docent09: '袁青'
};

const normalLocations = ['LOC_A', 'LOC_B', 'LOC_C', 'EXHIBIT_HALL_1', 'EXHIBIT_HALL_2', 'STORAGE_ROOM_3', 'LOC_VIP'];
const repairLocations = ['RESTORATION_ROOM', 'LOC_D'];
const standardPreservations = ['COMPLETE', 'BASIC_COMPLETE'];
const repairablePreservations = ['INCOMPLETE', 'SEVERE_INCOMPLETE', 'FRAGMENTED', 'PHYSICAL_DAMAGE', 'CHEMICAL_DEGRADATION', 'BIOLOGICAL_DISEASE'];
const protectionLevels = ['一级', '二级', '三级', '一般'];

const profiles = [
  ['BRONZE_WARE', ['BRONZE'], ['西周', '春秋', '战国', '汉代', '唐代'], ['兽面纹', '蟠螭纹', '云雷纹', '错金银', '铭文'], ['鼎', '簋', '壶', '尊', '镜', '带钩'], ['考古发掘入藏', '旧藏整理', '馆际征集']],
  ['CERAMIC', ['PORCELAIN', 'CLAY'], ['唐代', '宋代', '元代', '明代', '清代', '民国'], ['青花', '粉彩', '刻花', '印花', '白釉', '影青'], ['梅瓶', '执壶', '盘口壶', '盘', '碗', '罐', '香炉'], ['社会捐赠', '考古发掘入藏', '征集购藏']],
  ['PAINTING_CALLIGRAPHY', ['PAPER', 'SILK'], ['宋代', '元代', '明代', '清代', '民国'], ['山水', '花鸟', '墨竹', '行书', '楷书', '仕女'], ['手卷', '立轴', '册页', '扇面'], ['旧藏移交', '社会捐赠', '馆际征集']],
  ['JADE_ARTIFACT', ['JADE'], ['新石器时代', '商代', '战国', '汉代', '清代'], ['谷纹', '云龙纹', '螭龙纹', '素面', '凤鸟纹'], ['玉璧', '玉佩', '玉圭', '玉琮', '带钩'], ['馆际调拨', '考古发掘入藏', '社会捐赠']],
  ['GOLD_SILVER_WARE', ['GOLD', 'SILVER'], ['唐代', '宋代', '明代', '清代'], ['鎏金', '錾花', '累丝', '掐丝', '錾刻'], ['冠饰', '香囊', '银盘', '带扣', '执壶'], ['馆际征集', '社会捐赠', '旧藏整理']],
  ['WOOD', ['WOOD', 'BAMBOO_WOOD'], ['明代', '清代', '民国'], ['紫檀雕花', '柏木髹漆', '黄花梨', '楠木透雕', '描金'], ['屏风', '经匣', '佛像', '香几', '供案'], ['寺院征集', '馆际调拨', '社会捐赠']],
  ['LACQUER', ['LACQUER_WOOD'], ['战国', '汉代', '明代', '清代', '民国'], ['剔红', '描金', '黑漆', '朱漆', '戗金'], ['漆盒', '漆盘', '漆奁', '漆壶'], ['征集购藏', '旧藏移交', '社会捐赠']],
  ['STONE', ['STONE'], ['北魏', '北齐', '唐代', '宋代'], ['莲花座', '菩萨', '佛首', '经幢', '造像碑'], ['立像', '坐像', '石刻残件', '供养人像'], ['寺院征集', '考古发掘入藏', '馆际移交']],
  ['BAMBOO', ['BAMBOO_WOOD'], ['战国', '汉代', '宋代', '明代'], ['简牍', '墨书', '编联', '题记', '漆书'], ['竹简', '木牍', '册页', '卷册'], ['考古发掘入藏', '学术移交', '馆际征集']]
].map(([categoryCode, materials, eras, prefixes, items, sources]) => ({ categoryCode, materials, eras, prefixes, items, sources }));

const storageConditionMap = {
  BRONZE: '干燥存放，温度18至24度，相对湿度45%至55%，防止锈蚀继续扩散。',
  PORCELAIN: '防震托架单件存放，避免温差突变与硬物碰撞。',
  CLAY: '低震动环境保存，配合缓冲支撑，防止胎体继续开裂。',
  PAPER: '避光平放，温度18至20度，相对湿度50%至55%，减少酸化风险。',
  SILK: '平铺或悬挂缓释支撑，避光防尘，控制湿度波动。',
  JADE: '独立柜架保存，防碰撞、防油污，定期观察表面风化。',
  GOLD: '恒温低湿保存，避免与含硫物质长期接触。',
  SILVER: '干燥密闭保存，配合防氧化材料，减少表面发黑。',
  WOOD: '恒温恒湿环境保存，避免直射光和虫蛀滋生。',
  BAMBOO_WOOD: '防虫防霉，保持缓慢通风，搬运时使用托板支撑。',
  LACQUER_WOOD: '避免阳光直射和湿热环境，表面禁止硬物摩擦。',
  STONE: '独立底座承托，控制展柜粉尘和局部潮气。'
};

const attentionMap = {
  COMPLETE: '常规巡检即可，适合常设展陈或常规库房管理。',
  BASIC_COMPLETE: '搬运时需加缓冲垫，避免高频流转。',
  INCOMPLETE: '局部残缺，调阅与搬运需双人复核。',
  SEVERE_INCOMPLETE: '结构脆弱，原则上仅允许修复评估与专项查看。',
  FRAGMENTED: '残碎件较多，需分件编号和托盘存放。',
  PHYSICAL_DAMAGE: '存在裂缝或断口，禁止直接陈列与频繁移动。',
  CHEMICAL_DEGRADATION: '需重点监测表面腐蚀、粉化或漆层脱落。',
  BIOLOGICAL_DISEASE: '注意霉斑、虫蛀等病害复发，需定期检查。'
};

const inboundSources = ['社会征集入藏', '馆际调拨入藏', '考古发掘入藏', '旧藏整理建档', '专题征集入藏'];
const outboundPurposes = ['馆际交流展', '专题临展借展', '学术研究调阅', '数字化采集外拍', '文保评估送检'];
const outboundDestinations = ['省博物院交流展厅', '市文化馆联合展区', '高校文博实验室', '文物保护中心', '馆外数字采集点'];
const repairReasons = ['器表腐蚀加重，需要开展清理与稳定性加固。', '存在裂隙与结构松动，需要进行加固处理。', '表层彩绘起翘，需要实施病害处置。', '馆藏调阅中发现局部缺损，需要修复评估。', '长期存放后病害复发，需要重新修复。'];
const repairPlanTitles = ['修复方案', '病害处置方案', '加固与补配方案', '清理与稳定化方案'];
const repairMaterials = ['无酸纸、支撑纱、加固剂', '明胶、脱盐水、缓冲棉', '矿物颜料、保护胶、无纺布', '支撑架、树脂材料、记录标签'];
const repairRisks = ['施工过程中需控制局部受力，避免二次损伤。', '修复前后均需完成高清影像留存。', '病害处置完成后需安排阶段性复核。', '涉及彩绘与表面层的操作应减少接触频次。'];
const repairSteps = ['病害复核', '表面清理', '裂隙处理', '结构加固', '补配与校正', '颜色协调', '记录归档'];
const repairOps = ['完成病害点位复核并建立修复影像记录。', '对表面浮尘、附着物进行低干预清理。', '对裂隙与断口进行支撑固定和局部黏结。', '针对脆弱部位开展加固处理并完成稳定性复核。', '完成局部补配、校正与协调处理。', '补录修复过程资料并形成归档说明。'];

const relics = [];
for (let index = 1; index <= 200; index += 1) {
  let scenario = 'STOCK_NORMAL';
  if (index > 100 && index <= 120) scenario = 'OUTBOUND_PENDING';
  else if (index > 120 && index <= 135) scenario = 'OUT_STOCK';
  else if (index > 135 && index <= 145) scenario = 'REPAIR_IN_PROGRESS';
  else if (index > 145 && index <= 153) scenario = 'REPAIR_WAITING';
  else if (index > 153 && index <= 163) scenario = 'REPAIR_APPLIED';
  else if (index > 163 && index <= 170) scenario = 'REPAIR_APPROVED';
  else if (index > 170 && index <= 175) scenario = 'REPAIR_ACCEPTED';
  else if (index > 175 && index <= 180) scenario = 'REPAIR_REJECTED';
  else if (index > 180 && index <= 190) scenario = 'RETURNED_HISTORY';
  else if (index > 190) scenario = 'OUTBOUND_REJECTED';

  const profile = profiles[(index - 1) % profiles.length];
  const era = pick(profile.eras);
  const materialCode = pick(profile.materials);
  const prefix = profile.prefixes[(index + Math.floor(rand() * 3)) % profile.prefixes.length];
  const item = profile.items[(index + Math.floor(rand() * 5)) % profile.items.length];
  const relicNo = `REL-DEMO-2026-${pad(index, 4)}`;
  const operatorUsername = researchers[index % researchers.length];
  let currentStatus = 'IN_STOCK';
  let preservationStatusCode = pick([...standardPreservations, 'INCOMPLETE']);
  let storageLocationCode = pick(normalLocations);
  if (scenario === 'OUTBOUND_PENDING') {
    currentStatus = 'OUTBOUND_PENDING';
    preservationStatusCode = pick(standardPreservations);
    storageLocationCode = pick(['LOC_A', 'LOC_B', 'EXHIBIT_HALL_1', 'EXHIBIT_HALL_2', 'TEMP_STORAGE']);
  } else if (scenario === 'OUT_STOCK') {
    currentStatus = 'OUT_STOCK';
    preservationStatusCode = pick(standardPreservations);
    storageLocationCode = pick(['LOC_A', 'LOC_B', 'LOC_C', 'EXHIBIT_HALL_1']);
  } else if (['REPAIR_IN_PROGRESS', 'REPAIR_WAITING'].includes(scenario)) {
    currentStatus = 'IN_REPAIR';
    preservationStatusCode = pick(repairablePreservations);
    storageLocationCode = pick(repairLocations);
  } else if (['REPAIR_APPLIED', 'REPAIR_APPROVED', 'REPAIR_REJECTED'].includes(scenario)) {
    preservationStatusCode = pick(repairablePreservations);
    storageLocationCode = pick(['LOC_B', 'LOC_C', 'LOC_D', 'STORAGE_ROOM_3']);
  } else if (scenario === 'REPAIR_ACCEPTED') {
    preservationStatusCode = pick(['COMPLETE', 'BASIC_COMPLETE']);
    storageLocationCode = pick(['LOC_A', 'LOC_B', 'LOC_VIP', 'EXHIBIT_HALL_1']);
  }
  const createTime = daysAgo(640 - index * 2, 9 + (index % 7), (index * 7) % 60);
  relics.push({
    relicNo,
    name: `${era}${prefix}${item}`,
    categoryCode: profile.categoryCode,
    materialCode,
    era,
    source: pick(profile.sources),
    storageLocationCode,
    preservationStatusCode,
    currentStatus,
    protectionLevel: pick(protectionLevels),
    storageCondition: storageConditionMap[materialCode],
    attentionNote: attentionMap[preservationStatusCode],
    description: `用于馆藏建档、库存查询、出入库流转、修复跟踪和答辩演示的模拟馆藏文物档案。`,
    note: '批量生成的测试数据，可用于分页、筛选、审批、盘点和修复流程联调。',
    operatorUsername,
    createTime,
    scenario
  });
}

const inboundOrders = chunk(relics, 5).map((group, index) => ({
  orderNo: `IN-DEMO-2026-${pad(index + 1, 3)}`,
  batchNo: `BATCH-DEMO-2026-${pad(index + 1, 3)}`,
  source: pick(inboundSources),
  handlerUsername: researchers[index % researchers.length],
  inboundTime: new Date(group[group.length - 1].createTime.getTime() + 1000 * 60 * 60 * 24 * 2),
  remark: `批量生成的入藏建档单，共包含 ${group.length} 件文物。`,
  relics: group
}));

const outboundGroups = [];
chunk(relics.filter((r) => r.scenario === 'OUTBOUND_PENDING'), 2).forEach((g) => outboundGroups.push({ status: 'PENDING', relics: g }));
chunk(relics.filter((r) => r.scenario === 'OUT_STOCK'), 2).forEach((g) => outboundGroups.push({ status: 'APPROVED', relics: g }));
chunk(relics.filter((r) => r.scenario === 'RETURNED_HISTORY'), 2).forEach((g) => outboundGroups.push({ status: 'RETURNED', relics: g }));
chunk(relics.filter((r) => r.scenario === 'OUTBOUND_REJECTED'), 2).forEach((g) => outboundGroups.push({ status: 'REJECTED', relics: g }));

const outboundOrders = outboundGroups.map((group, index) => {
  const applyUsername = researchers[index % researchers.length];
  const approveUsername = admins[index % admins.length];
  const applyTime = new Date(group.relics[0].createTime.getTime() + 1000 * 60 * 60 * 24 * 18);
  const approveTime = group.status === 'PENDING' ? null : new Date(applyTime.getTime() + 1000 * 60 * 60 * 24);
  const returnTime = group.status === 'RETURNED' ? new Date(applyTime.getTime() + 1000 * 60 * 60 * 24 * 18) : null;
  const remarkMap = { APPROVED: '审批通过，已完成交接出库。', RETURNED: '审批通过，已完成借展并回库登记。', REJECTED: '借展条件未满足，驳回本次申请。' };
  return {
    orderNo: `OUT-DEMO-2026-${pad(index + 1, 3)}`,
    purpose: pick(outboundPurposes),
    destination: pick(outboundDestinations),
    handlerName: nameMap[applyUsername],
    applyUsername,
    approveUsername,
    approveStatus: group.status,
    outboundTime: applyTime,
    approveTime,
    approveRemark: remarkMap[group.status] || null,
    returnTime,
    remark: `批量生成的出库业务单，共 ${group.relics.length} 件文物。`,
    relics: group.relics
  };
});

const repairBuckets = {
  APPLIED: relics.filter((r) => r.scenario === 'REPAIR_APPLIED'),
  APPROVED: relics.filter((r) => r.scenario === 'REPAIR_APPROVED'),
  IN_PROGRESS: relics.filter((r) => r.scenario === 'REPAIR_IN_PROGRESS'),
  COMPLETED: relics.filter((r) => r.scenario === 'REPAIR_WAITING'),
  ACCEPTED: relics.filter((r) => r.scenario === 'REPAIR_ACCEPTED'),
  REJECTED: relics.filter((r) => r.scenario === 'REPAIR_REJECTED')
};

const repairTasks = [];
let repairIndex = 1;
for (const [status, bucket] of Object.entries(repairBuckets)) {
  bucket.forEach((relic, index) => {
    const applyTime = new Date(relic.createTime.getTime() + 1000 * 60 * 60 * 24 * 28);
    const approveTime = ['APPROVED', 'IN_PROGRESS', 'COMPLETED', 'ACCEPTED', 'REJECTED'].includes(status) ? new Date(applyTime.getTime() + 1000 * 60 * 60 * 24) : null;
    const startTime = ['IN_PROGRESS', 'COMPLETED', 'ACCEPTED'].includes(status) ? new Date(applyTime.getTime() + 1000 * 60 * 60 * 24 * 2) : null;
    const endTime = ['COMPLETED', 'ACCEPTED'].includes(status) ? new Date(applyTime.getTime() + 1000 * 60 * 60 * 24 * (10 + (index % 4))) : null;
    repairTasks.push({
      taskNo: `REP-DEMO-2026-${pad(repairIndex, 3)}`,
      relic,
      applyUsername: researchers[(repairIndex + 2) % researchers.length],
      approveUsername: admins[(repairIndex + 1) % admins.length],
      taskStatus: status,
      acceptanceStatus: status === 'ACCEPTED' ? 'SUCCESS' : status === 'COMPLETED' ? 'WAITING' : 'UNACCEPTED',
      applyReason: repairReasons[repairIndex % repairReasons.length],
      approveRemark: status === 'REJECTED' ? '当前病害风险可控，建议先加强保管观察。' : status === 'APPLIED' ? null : '审批通过，按方案推进修复。',
      applyTime, approveTime, startTime, endTime, remark: '批量生成的修复业务测试数据。'
    });
    repairIndex += 1;
  });
}

const repairPlans = repairTasks.filter((t) => ['APPROVED', 'IN_PROGRESS', 'COMPLETED', 'ACCEPTED'].includes(t.taskStatus)).map((task, index) => ({
  taskNo: task.taskNo,
  planNo: `PLAN-DEMO-2026-${pad(index + 1, 3)}`,
  planTitle: `${task.relic.name}${pick(repairPlanTitles)}`,
  planContent: `针对${task.relic.name}当前病害情况，拟采取清理、加固、补配、记录归档等步骤开展保护修复。`,
  materials: pick(repairMaterials),
  riskNote: pick(repairRisks),
  submitterName: nameMap[task.applyUsername],
  reviewerName: nameMap[task.approveUsername],
  reviewTime: task.approveTime || task.applyTime
}));

const repairLogs = [];
let repairLogIndex = 1;
repairTasks.filter((t) => ['IN_PROGRESS', 'COMPLETED', 'ACCEPTED'].includes(t.taskStatus)).forEach((task) => {
  const total = task.taskStatus === 'IN_PROGRESS' ? 2 : 3;
  for (let i = 0; i < total; i += 1) {
    repairLogs.push({
      taskNo: task.taskNo,
      logNo: `LOG-DEMO-2026-${pad(repairLogIndex, 3)}`,
      stepName: repairSteps[(repairLogIndex + i) % repairSteps.length],
      operationContent: repairOps[(repairLogIndex + i) % repairOps.length],
      materialsUsed: pick(repairMaterials),
      operatorName: nameMap[task.applyUsername],
      logTime: new Date((task.startTime || task.applyTime).getTime() + 1000 * 60 * 60 * 24 * i),
      progressStatus: i === total - 1 && task.taskStatus !== 'IN_PROGRESS' ? 'COMPLETED' : 'IN_PROGRESS'
    });
    repairLogIndex += 1;
  }
});

const repairAcceptances = repairTasks.filter((t) => t.taskStatus === 'ACCEPTED').map((task, index) => ({
  taskNo: task.taskNo,
  acceptanceNo: `ACC-DEMO-2026-${pad(index + 1, 3)}`,
  acceptanceBy: admins[index % admins.length],
  acceptanceTime: new Date(task.endTime.getTime() + 1000 * 60 * 60 * 6),
  acceptanceRemark: '修复质量符合馆藏验收要求，可转入常规保管。',
  followUpSuggestion: '建议三个月后复核病害稳定性并补录阶段性照片。'
}));

const inventoryConfigs = [
  ['INV-DEMO-2026-001', '一号综合库季度盘点', 'LOC_A', 'COMPLETED', 'researcher10', 32],
  ['INV-DEMO-2026-002', '二号恒温库专项盘点', 'LOC_B', 'COMPLETED', 'researcher10', 28],
  ['INV-DEMO-2026-003', '三号精品库重点盘点', 'LOC_C', 'IN_PROGRESS', 'researcher12', 24],
  ['INV-DEMO-2026-004', '一号展厅春季盘点', 'EXHIBIT_HALL_1', 'COMPLETED', 'researcher02', 21],
  ['INV-DEMO-2026-005', '二号展厅月度盘点', 'EXHIBIT_HALL_2', 'CREATED', 'researcher03', 18],
  ['INV-DEMO-2026-006', '三号库房保管复核', 'STORAGE_ROOM_3', 'IN_PROGRESS', 'researcher07', 17],
  ['INV-DEMO-2026-007', '修复库状态抽盘', 'LOC_D', 'COMPLETED', 'researcher11', 16],
  ['INV-DEMO-2026-008', '珍品专柜安全抽盘', 'LOC_VIP', 'COMPLETED', 'researcher06', 14],
  ['INV-DEMO-2026-009', '暂存区临时盘点', 'TEMP_STORAGE', 'CREATED', 'researcher14', 12],
  ['INV-DEMO-2026-010', '修复室在修文物盘点', 'RESTORATION_ROOM', 'IN_PROGRESS', 'researcher11', 9]
];

const inventoryTasks = inventoryConfigs.map(([no, name, locationCode, taskStatus, principalUsername, days]) => {
  const startTime = daysAgo(days, 9, 0);
  const endTime = taskStatus === 'COMPLETED' ? new Date(startTime.getTime() + 1000 * 60 * 60 * 8) : null;
  const details = relics.filter((r) => r.storageLocationCode === locationCode).slice(0, 12).map((relic, index) => {
    let resultStatus = 'PENDING';
    let actualQuantity = null;
    let diffQuantity = null;
    let diffRemark = null;
    if (taskStatus === 'COMPLETED') {
      resultStatus = index % 6 === 0 ? 'DIFF_FOUND' : index % 5 === 0 ? 'CHECKED' : 'NORMAL';
      actualQuantity = resultStatus === 'DIFF_FOUND' ? 0 : 1;
      diffQuantity = resultStatus === 'DIFF_FOUND' ? -1 : 0;
      diffRemark = resultStatus === 'DIFF_FOUND' ? '盘点时文物暂未在指定库位发现，已发起复核。' : null;
    } else if (taskStatus === 'IN_PROGRESS') {
      resultStatus = index % 4 === 0 ? 'PENDING' : index % 3 === 0 ? 'DIFF_FOUND' : 'NORMAL';
      actualQuantity = resultStatus === 'PENDING' ? null : resultStatus === 'DIFF_FOUND' ? 0 : 1;
      diffQuantity = resultStatus === 'PENDING' ? null : resultStatus === 'DIFF_FOUND' ? -1 : 0;
      diffRemark = resultStatus === 'DIFF_FOUND' ? '现场复核中，待确认临时调拨记录。' : null;
    }
    return { relic, resultStatus, actualQuantity, diffQuantity, diffRemark };
  });
  return { no, name, locationCode, taskStatus, principalUsername, principalName: nameMap[principalUsername], startTime, endTime, details };
});

const userPasswordVar = (role) => role === 'admin' ? '@seed_admin_hash' : role === 'researcher' ? '@seed_researcher_hash' : '@seed_docent_hash';
const lookupUserId = (username) => `COALESCE((SELECT id FROM sys_user WHERE username = ${sql(username)} AND deleted = 0 LIMIT 1), @seed_admin_id)`;
const attachmentSql = (relicNo, type, fileName, fileUrl, size, suffix, remark, time) => `
INSERT INTO relic_attachment (
  relic_id, attachment_type, file_name, file_url, file_size, file_suffix, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT r.id, ${sql(type)}, ${sql(fileName)}, ${sql(fileUrl)}, ${size}, ${sql(suffix)}, ${sql(remark)}, @seed_admin_id, ${dt(time)}, @seed_admin_id, ${dt(time)}, 0
FROM relic r
WHERE r.relic_no = ${sql(relicNo)} AND r.deleted = 0
  AND NOT EXISTS (
    SELECT 1 FROM relic_attachment a
    WHERE a.relic_id = r.id AND a.attachment_type = ${sql(type)} AND a.file_name = ${sql(fileName)} AND a.deleted = 0
  );`;

lines.push(
  '-- 博物馆文物综合管理平台批量测试数据 SQL',
  '-- 生成时间: 2026-04-08',
  '-- 导入方式: 使用 Navicat 打开本文件后直接执行',
  '',
  'SET NAMES utf8mb4;',
  'START TRANSACTION;',
  `SET @seed_admin_hash = COALESCE((SELECT password FROM sys_user WHERE username = 'admin' AND deleted = 0 LIMIT 1), ${sql(fallbackHashes.admin)});`,
  `SET @seed_researcher_hash = COALESCE((SELECT password FROM sys_user WHERE username = 'researcher' AND deleted = 0 LIMIT 1), ${sql(fallbackHashes.researcher)});`,
  `SET @seed_docent_hash = COALESCE((SELECT password FROM sys_user WHERE username = 'docent' AND deleted = 0 LIMIT 1), ${sql(fallbackHashes.docent)});`,
  "SET @seed_admin_id = COALESCE((SELECT id FROM sys_user WHERE username = 'admin' AND deleted = 0 LIMIT 1), 1);",
  ''
);

users.forEach((user, index) => {
  const createTime = daysAgo(90 - (index % 30), 10 + (index % 4), 15);
  const lastLoginTime = daysAgo(20 - (index % 7), 8 + (index % 3), 20);
  pushSql(`
INSERT INTO sys_user (
  username, password, nick_name, real_name, phone, email, gender, avatar_url, status, last_login_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT ${sql(user.username)}, ${userPasswordVar(user.roleCode)}, ${sql(user.nickName)}, ${sql(user.realName)}, ${sql(user.phone)}, ${sql(user.email)}, ${sql(user.gender)},
  NULL, 'ENABLED', ${dt(lastLoginTime)}, ${sql(`批量生成的${user.roleCode}测试账号。${user.remark}`)}, @seed_admin_id, ${dt(createTime)}, @seed_admin_id, ${dt(lastLoginTime)}, 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_user WHERE username = ${sql(user.username)} AND deleted = 0);`);

  pushSql(`
INSERT INTO sys_user_role (user_id, role_id, create_by, create_time, update_by, update_time, deleted)
SELECT u.id, r.id, @seed_admin_id, ${dt(createTime)}, @seed_admin_id, ${dt(createTime)}, 0
FROM sys_user u
JOIN sys_role r ON r.role_code = ${sql(user.roleCode)} AND r.deleted = 0
WHERE u.username = ${sql(user.username)} AND u.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM sys_user_role ur WHERE ur.user_id = u.id AND ur.role_id = r.id AND ur.deleted = 0);`);
});

relics.forEach((relic, index) => {
  pushSql(`
INSERT INTO relic (
  relic_no, name, category_code, material_code, era, source, storage_location_code, preservation_status_code, current_status, protection_level,
  storage_condition, attention_note, description, note, image_url, appraisal_report_url, create_by, create_time, update_by, update_time, deleted
)
SELECT ${sql(relic.relicNo)}, ${sql(relic.name)}, ${sql(relic.categoryCode)}, ${sql(relic.materialCode)}, ${sql(relic.era)}, ${sql(relic.source)},
  ${sql(relic.storageLocationCode)}, ${sql(relic.preservationStatusCode)}, ${sql(relic.currentStatus)}, ${sql(relic.protectionLevel)}, ${sql(relic.storageCondition)},
  ${sql(relic.attentionNote)}, ${sql(relic.description)}, ${sql(relic.note)}, ${sql(imageUrl)}, ${sql(reportUrl)},
  ${lookupUserId(relic.operatorUsername)}, ${dt(relic.createTime)}, ${lookupUserId(relic.operatorUsername)}, ${dt(new Date(relic.createTime.getTime() + 1000 * 60 * 90))}, 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic WHERE relic_no = ${sql(relic.relicNo)} AND deleted = 0);`);

  const t = new Date(relic.createTime.getTime() + 1000 * 60 * 60 * 2);
  pushSql(attachmentSql(relic.relicNo, 'IMAGE', `${relic.name}-主图.jpg`, imageUrl, 68, 'jpg', '批量生成的主图占位图片。', t));
  pushSql(attachmentSql(relic.relicNo, 'APPRAISAL_REPORT', `${relic.name}-鉴定说明.txt`, reportUrl, 24, 'txt', '批量生成的鉴定附件占位文件。', new Date(t.getTime() + 1000 * 60 * 5)));
  if (index % 3 === 0) {
    pushSql(attachmentSql(relic.relicNo, 'DOCUMENT', `${relic.name}-建档说明.txt`, docUrl, 24, 'txt', '批量生成的建档附件占位文件。', new Date(t.getTime() + 1000 * 60 * 10)));
  }
});

inboundOrders.forEach((order) => {
  pushSql(`
INSERT INTO relic_inbound_order (
  order_no, batch_no, source, handler_name, inbound_time, total_count, status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT ${sql(order.orderNo)}, ${sql(order.batchNo)}, ${sql(order.source)}, ${sql(nameMap[order.handlerUsername])}, ${dt(order.inboundTime)}, ${order.relics.length}, 'COMPLETED',
  ${sql(order.remark)}, ${lookupUserId(order.handlerUsername)}, ${dt(order.inboundTime)}, ${lookupUserId(order.handlerUsername)}, ${dt(order.inboundTime)}, 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_inbound_order WHERE order_no = ${sql(order.orderNo)} AND deleted = 0);`);

  order.relics.forEach((relic) => pushSql(`
INSERT INTO relic_inbound_detail (order_id, relic_id, relic_no, relic_name, quantity, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, ${sql(relic.relicNo)}, ${sql(relic.name)}, 1, ${sql('模拟入藏建档明细。')}, @seed_admin_id, ${dt(order.inboundTime)}, @seed_admin_id, ${dt(order.inboundTime)}, 0
FROM relic_inbound_order o
JOIN relic r ON r.relic_no = ${sql(relic.relicNo)} AND r.deleted = 0
WHERE o.order_no = ${sql(order.orderNo)} AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_inbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);`));
});

outboundOrders.forEach((order) => {
  pushSql(`
INSERT INTO relic_outbound_order (
  order_no, purpose, destination, handler_name, outbound_time, apply_user_id, approve_status, approve_by, approve_time, approve_remark,
  return_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT ${sql(order.orderNo)}, ${sql(order.purpose)}, ${sql(order.destination)}, ${sql(order.handlerName)}, ${dt(order.outboundTime)}, ${lookupUserId(order.applyUsername)},
  ${sql(order.approveStatus)}, ${order.approveTime ? lookupUserId(order.approveUsername) : 'NULL'}, ${order.approveTime ? dt(order.approveTime) : 'NULL'},
  ${sql(order.approveRemark)}, ${order.returnTime ? dt(order.returnTime) : 'NULL'}, ${sql(order.remark)},
  ${lookupUserId(order.applyUsername)}, ${dt(order.outboundTime)}, ${lookupUserId(order.approveTime ? order.approveUsername : order.applyUsername)}, ${dt(order.returnTime || order.approveTime || order.outboundTime)}, 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM relic_outbound_order WHERE order_no = ${sql(order.orderNo)} AND deleted = 0);`);

  order.relics.forEach((relic) => pushSql(`
INSERT INTO relic_outbound_detail (order_id, relic_id, relic_no, relic_name, quantity, current_status_snapshot, remark, create_by, create_time, update_by, update_time, deleted)
SELECT o.id, r.id, ${sql(relic.relicNo)}, ${sql(relic.name)}, 1, 'IN_STOCK', ${sql('模拟出库业务明细。')}, @seed_admin_id, ${dt(order.outboundTime)}, @seed_admin_id, ${dt(order.outboundTime)}, 0
FROM relic_outbound_order o
JOIN relic r ON r.relic_no = ${sql(relic.relicNo)} AND r.deleted = 0
WHERE o.order_no = ${sql(order.orderNo)} AND o.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM relic_outbound_detail d WHERE d.order_id = o.id AND d.relic_id = r.id AND d.deleted = 0);`));
});

repairTasks.forEach((task) => {
  pushSql(`
INSERT INTO repair_task (
  task_no, relic_id, relic_no, relic_name, apply_user_id, apply_reason, task_status, acceptance_status, apply_time, approve_by, approve_time,
  approve_remark, start_time, end_time, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT ${sql(task.taskNo)}, r.id, ${sql(task.relic.relicNo)}, ${sql(task.relic.name)}, ${lookupUserId(task.applyUsername)}, ${sql(task.applyReason)},
  ${sql(task.taskStatus)}, ${sql(task.acceptanceStatus)}, ${dt(task.applyTime)}, ${task.approveTime ? lookupUserId(task.approveUsername) : 'NULL'},
  ${task.approveTime ? dt(task.approveTime) : 'NULL'}, ${sql(task.approveRemark)}, ${task.startTime ? dt(task.startTime) : 'NULL'}, ${task.endTime ? dt(task.endTime) : 'NULL'},
  ${sql(task.remark)}, ${lookupUserId(task.applyUsername)}, ${dt(task.applyTime)}, ${lookupUserId(task.approveTime ? task.approveUsername : task.applyUsername)}, ${dt(task.endTime || task.startTime || task.approveTime || task.applyTime)}, 0
FROM relic r
WHERE r.relic_no = ${sql(task.relic.relicNo)} AND r.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_task WHERE task_no = ${sql(task.taskNo)} AND deleted = 0);`);

  if (['IN_PROGRESS', 'COMPLETED', 'ACCEPTED'].includes(task.taskStatus)) {
    const fileTime = task.startTime || task.applyTime;
    pushSql(attachmentSql(task.relic.relicNo, 'REPAIR_IMAGE', `${task.relic.name}-修复过程图.png`, imageUrl, 68, 'png', '批量生成的修复过程图片占位文件。', fileTime));
    pushSql(attachmentSql(task.relic.relicNo, 'REPAIR_FILE', `${task.relic.name}-修复说明.txt`, repairFileUrl, 24, 'txt', '批量生成的修复说明占位文件。', new Date(fileTime.getTime() + 1000 * 60 * 30)));
  }
});

repairPlans.forEach((plan) => pushSql(`
INSERT INTO repair_plan (
  repair_task_id, plan_no, plan_title, plan_content, materials, risk_note, plan_status, submitter_name, reviewer_name, review_time, review_remark,
  create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, ${sql(plan.planNo)}, ${sql(plan.planTitle)}, ${sql(plan.planContent)}, ${sql(plan.materials)}, ${sql(plan.riskNote)}, 'APPROVED',
  ${sql(plan.submitterName)}, ${sql(plan.reviewerName)}, ${dt(plan.reviewTime)}, ${sql('方案内容完整，可按计划执行。')}, @seed_admin_id, ${dt(plan.reviewTime)}, @seed_admin_id, ${dt(plan.reviewTime)}, 0
FROM repair_task t
WHERE t.task_no = ${sql(plan.taskNo)} AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_plan p WHERE p.repair_task_id = t.id AND p.deleted = 0);`));

repairLogs.forEach((log) => pushSql(`
INSERT INTO repair_log (
  repair_task_id, log_no, step_name, operation_content, materials_used, operator_name, log_time, progress_status, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, ${sql(log.logNo)}, ${sql(log.stepName)}, ${sql(log.operationContent)}, ${sql(log.materialsUsed)}, ${sql(log.operatorName)}, ${dt(log.logTime)},
  ${sql(log.progressStatus)}, ${sql('批量生成的修复过程记录。')}, @seed_admin_id, ${dt(log.logTime)}, @seed_admin_id, ${dt(log.logTime)}, 0
FROM repair_task t
WHERE t.task_no = ${sql(log.taskNo)} AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_log WHERE log_no = ${sql(log.logNo)} AND deleted = 0);`));

repairAcceptances.forEach((item) => pushSql(`
INSERT INTO repair_acceptance (
  repair_task_id, acceptance_no, acceptance_result, acceptance_by, acceptance_time, acceptance_remark, follow_up_suggestion, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, ${sql(item.acceptanceNo)}, 'PASS', ${lookupUserId(item.acceptanceBy)}, ${dt(item.acceptanceTime)}, ${sql(item.acceptanceRemark)}, ${sql(item.followUpSuggestion)},
  @seed_admin_id, ${dt(item.acceptanceTime)}, @seed_admin_id, ${dt(item.acceptanceTime)}, 0
FROM repair_task t
WHERE t.task_no = ${sql(item.taskNo)} AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM repair_acceptance a WHERE a.repair_task_id = t.id AND a.deleted = 0);`));

inventoryTasks.forEach((task) => {
  pushSql(`
INSERT INTO inventory_task (
  task_no, task_name, location_code, task_status, start_time, end_time, principal_name, remark, create_by, create_time, update_by, update_time, deleted
)
SELECT ${sql(task.no)}, ${sql(task.name)}, ${sql(task.locationCode)}, ${sql(task.taskStatus)}, ${dt(task.startTime)}, ${task.endTime ? dt(task.endTime) : 'NULL'}, ${sql(task.principalName)},
  ${sql('批量生成的盘点任务数据。')}, ${lookupUserId(task.principalUsername)}, ${dt(task.startTime)}, ${lookupUserId(task.principalUsername)}, ${dt(task.endTime || task.startTime)}, 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM inventory_task WHERE task_no = ${sql(task.no)} AND deleted = 0);`);

  task.details.forEach((detail, index) => pushSql(`
INSERT INTO inventory_task_detail (
  task_id, relic_id, relic_no, relic_name, system_quantity, actual_quantity, diff_quantity, diff_remark, result_status, create_by, create_time, update_by, update_time, deleted
)
SELECT t.id, r.id, ${sql(detail.relic.relicNo)}, ${sql(detail.relic.name)}, 1, ${detail.actualQuantity == null ? 'NULL' : detail.actualQuantity},
  ${detail.diffQuantity == null ? 'NULL' : detail.diffQuantity}, ${sql(detail.diffRemark)}, ${sql(detail.resultStatus)},
  @seed_admin_id, ${dt(new Date(task.startTime.getTime() + 1000 * 60 * 12 * index))}, @seed_admin_id, ${dt(task.endTime || task.startTime)}, 0
FROM inventory_task t
JOIN relic r ON r.relic_no = ${sql(detail.relic.relicNo)} AND r.deleted = 0
WHERE t.task_no = ${sql(task.no)} AND t.deleted = 0
  AND NOT EXISTS (SELECT 1 FROM inventory_task_detail d WHERE d.task_id = t.id AND d.relic_id = r.id AND d.deleted = 0);`));
});

lines.push(
  'COMMIT;',
  '',
  '-- 导入后可执行以下核对 SQL',
  '-- SELECT COUNT(*) AS sys_user_count FROM sys_user WHERE deleted = 0;',
  '-- SELECT COUNT(*) AS relic_count FROM relic WHERE deleted = 0;',
  '-- SELECT COUNT(*) AS inbound_count FROM relic_inbound_order WHERE deleted = 0;',
  '-- SELECT COUNT(*) AS outbound_count FROM relic_outbound_order WHERE deleted = 0;',
  '-- SELECT COUNT(*) AS inventory_task_count FROM inventory_task WHERE deleted = 0;',
  '-- SELECT COUNT(*) AS repair_task_count FROM repair_task WHERE deleted = 0;'
);

fs.mkdirSync(outputDir, { recursive: true });
fs.writeFileSync(outputFile, `\uFEFF${lines.join('\n')}\n`, 'utf8');

console.log(`Generated ${outputFile}`);
console.log(`Users=${users.length} Relics=${relics.length} Inbound=${inboundOrders.length} Outbound=${outboundOrders.length} Inventory=${inventoryTasks.length} Repair=${repairTasks.length}`);
