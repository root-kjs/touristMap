package user.util;

import java.io.*;
import java.util.*;

public class CsvUtil {

    /**
     * [강사2025-09-11] CSV 파일 → List<Map<String, Object>> 읽기
     * - CSV 첫 줄(header)을 key로 사용
     * - 각 행을 Map으로 변환 후 list에 추가
     * @param filePath 읽을 CSV 파일 경로
     * @return List<Map<String, Object>> 형식 데이터
     */
    public static List<Map<String, Object>> read(String filePath) throws IOException {
        List<Map<String, Object>> list = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {

            // [강사2025-09-11] 1. 첫 줄 = 헤더 (컬럼명)
            String headerLine = br.readLine();
            if (headerLine == null) return list; // 비어 있으면 바로 반환

            String[] headers = headerLine.split(",");

            // [강사2025-09-11] 2. 데이터 행(line)을 순차적으로 읽음
            String line;
            while ((line = br.readLine()) != null) {
                // -1 옵션: 빈 문자열("")도 인식
                String[] values = line.split(",", -1);
                Map<String, Object> row = new LinkedHashMap<>();

                // [강사2025-09-11] 3. 헤더와 값 매칭하여 Map에 저장
                for (int i = 0; i < headers.length; i++) {
                    row.put(headers[i], values.length > i ? values[i] : "");
                }
                list.add(row); // 한 행(Map)을 리스트에 추가
            }
        }
        return list; // [강사2025-09-11] 최종적으로 List<Map> 반환
    }

    /**
     * [강사2025-09-11] List<Map<String,Object>> → CSV 파일 쓰기
     * - Map의 key = 헤더, value = 값
     * - 파일 경로에 디렉토리가 없으면 자동 생성
     * @param filePath 저장할 CSV 파일 경로
     * @param data 저장할 데이터
     */
    public static void write(String filePath, List<Map<String, Object>> data) throws IOException {
        if (data == null || data.isEmpty()) return; // [강사2025-09-11] 데이터 없으면 종료

        // [강사2025-09-11] 디렉토리 없으면 생성
        File file = new File(filePath);
        file.getParentFile().mkdirs();

        try (BufferedWriter bw = new BufferedWriter(new FileWriter(file))) {
            // [강사2025-09-11] 1. 헤더 작성 (첫 Map의 keySet 사용)
            Set<String> headers = data.get(0).keySet();
            bw.write(String.join(",", headers));
            bw.newLine();

            // [강사2025-09-11] 2. 데이터 행 작성
            for (Map<String, Object> row : data) {
                List<String> values = new ArrayList<>();
                for (String key : headers) {
                    Object val = row.getOrDefault(key, "");
                    // [강사2025-09-11] 쉼표가 들어간 값은 공백으로 치환 (CSV 구조 깨짐 방지)
                    String safe = val.toString().replace(",", " ");
                    values.add(safe);
                }
                bw.write(String.join(",", values));
                bw.newLine();
            }
        }
    }
}