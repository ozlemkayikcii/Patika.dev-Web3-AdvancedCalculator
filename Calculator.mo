import Float "mo:base/Float";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";

actor AdvancedCalc {
    var cell : Float = 0;
    let MAX_VALUE : Float = 1e38;
    let MIN_VALUE : Float = -1e38;

    // Hata yönetimi için variant türü
    type CalcResult = {
        #ok : Float;
        #err : Text;
    };

    // Değer kontrolü için yardımcı fonksiyon
    private func checkValue(value : Float) : async () {
        if (Float.abs(value) > MAX_VALUE) {
            Debug.print("Uyarı: Değer çok büyük, sonuçlar hatalı olabilir.");
        };
    };

    // Temel işlemler
    public func add(n : Float) : async Float {
        let result = cell + n;
        await checkValue(result);
        cell := result;
        cell
    };

    public func sub(n : Float) : async Float {
        let result = cell - n;
        await checkValue(result);
        cell := result;
        cell
    };

    public func mul(n : Float) : async Float {
        let result = cell * n;
        await checkValue(result);
        cell := result;
        cell
    };

    public func div(n : Float) : async CalcResult {
        if (n == 0) {
            #err("Sıfıra bölme hatası")
        } else {
            let result = cell / n;
            await checkValue(result);
            cell := result;
            #ok(cell)
        }
    };

    // Kök alma
    public func sqrt() : async CalcResult {
        if (cell < 0) {
            #err("Negatif sayının karekökü alınamaz")
        } else {
            let result = Float.sqrt(cell);
            await checkValue(result);
            cell := result;
            #ok(cell)
        }
    };

    // Üs alma
    public func pow(n : Float) : async CalcResult {
        if (cell == 0 and n < 0) {
            #err("Sıfırın negatif kuvveti tanımsızdır")
        } else {
            let result = Float.pow(cell, n);
            await checkValue(result);
            cell := result;
            #ok(cell)
        }
    };

    // İntegral (basit lineer fonksiyon için)
    public func integral(m : Float, b : Float, lowerBound : Float, upperBound : Float) : async Float {
        let result = (m * (upperBound ** 2 - lowerBound ** 2) / 2) + (b * (upperBound - lowerBound));
        await checkValue(result);
        cell := result;
        cell
    };

    // Mod alma
    public func mod(n : Int) : async CalcResult {
        if (n == 0) {
            #err("Sıfıra göre mod alınamaz")
        } else {
            let intCell = Int.abs(Float.toInt(cell));
            let result = intCell % n;
            cell := Float.fromInt(result);
            #ok(cell)
        }
    };

    // Mutlak değer
    public func abs() : async Float {
        cell := Float.abs(cell);
        cell
    };

    // Logaritma (doğal logaritma)
    public func ln() : async CalcResult {
        if (cell <= 0) {
            #err("Sıfır veya negatif sayının logaritması alınamaz")
        } else {
            let result = Float.log(cell);
            await checkValue(result);
            cell := result;
            #ok(cell)
        }
    };

    // Faktöriyel
    public func factorial() : async CalcResult {
        let n = Int.abs(Float.toInt(cell));
        if (n > 20) {
            #err("20'den büyük sayıların faktöriyeli hesaplanamaz")
        } else {
            var result = 1;
            for (i in Iter.range(1, n)) {
                result *= i;
            };
            cell := Float.fromInt(result);
            #ok(Float.fromInt(result))
        }
    };

    // Hesap makinesini temizle ve hücreyi sıfırla
    public func clearall() : async () {
        cell := 0;
    };

    // Mevcut değeri getir
    public func getValue() : async Float {
        cell
    };
};