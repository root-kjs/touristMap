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
            // 1. 헤더 읽기
            String headerLine = br.readLine();
            if (headerLine == null) return list;
            String[] headers = headerLine.split(",");

            // 2. 데이터 행
            String line;
            while ((line = br.readLine()) != null) {
                Map<String, Object> row = new LinkedHashMap<>();

                int start = 0;
                int headerIndex = 0;
                for (int i = 0; i < line.length(); i++) {
                    if (line.charAt(i) == ',') {
                        String value = line.substring(start, i);
                        row.put(headers[headerIndex++], value);
                        start = i + 1;
                    }
                }
                // 마지막 값
                row.put(headers[headerIndex++], line.substring(start));

                // 남는 헤더가 있다면 빈 값 채우기
                while (headerIndex < headers.length) {
                    row.put(headers[headerIndex++], "");
                }

                list.add(row);
            }
        }
        return list;
    }
    /**
     * [강사2025-09-11] List<Map<String,Object>> → CSV 파일 쓰기
     * - Map의 key = 헤더, value = 값
     * - 파일 경로에 디렉토리가 없으면 자동 생성
     * @param filePath 저장할 CSV 파일 경로
     * @param data 저장할 데이터
     */
    public static void write(String filePath, List<Map<String, Object>> data) throws IOException {
        if (data == null || data.isEmpty()) return; // 데이터 없으면 종료

        File file = new File(filePath);
        if (file.getParentFile() != null) {
            file.getParentFile().mkdirs(); // 디렉토리 생성
        }

        // try-with-resources → 자동 close
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(file))) {
            // 1. 헤더 (순서 고정)
            Set<String> headers = data.get(0).keySet();
            List<String> headerList = new ArrayList<>(headers);
            bw.write(String.join(",", headerList));
            bw.newLine();

            // 2. 데이터 행
            StringBuilder sb = new StringBuilder(256); // 재사용 버퍼
            int rowCount = 0;

            for (Map<String, Object> row : data) {
                sb.setLength(0); // 버퍼 초기화
                for (int i = 0; i < headerList.size(); i++) {
                    if (i > 0) sb.append(','); // 콤마 구분
                    Object val = row.getOrDefault(headerList.get(i), "");
                    // 쉼표 → 공백 치환 (혹은 CSV escape 필요시 따옴표 처리 가능)
                    sb.append(val == null ? "" : val.toString().replace(",", " "));
                }
                bw.write(sb.toString());
                bw.newLine();

                // 대용량일 때 메모리 flush
                if (++rowCount % 10000 == 0) {
                    bw.flush();
                }
            }
        }
    }
}