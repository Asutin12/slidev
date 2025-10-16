// React Hooks のパターン例

import { useState, useEffect, useCallback, useMemo } from "react";

// カスタムフック：APIデータフェッチ
function useApi<T>(url: string) {
  const [data, setData] = useState<T | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true);
        const response = await fetch(url);
        if (!response.ok) throw new Error("Failed to fetch");
        const result = await response.json();
        setData(result);
      } catch (err) {
        setError(err instanceof Error ? err.message : "Unknown error");
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, [url]);

  return { data, loading, error };
}

// カスタムフック：ローカルストレージ
function useLocalStorage<T>(key: string, initialValue: T) {
  const [storedValue, setStoredValue] = useState<T>(() => {
    try {
      const item = window.localStorage.getItem(key);
      return item ? JSON.parse(item) : initialValue;
    } catch (error) {
      return initialValue;
    }
  });

  const setValue = useCallback((value: T | ((val: T) => T)) => {
    try {
      const valueToStore = value instanceof Function ? value(storedValue) : value;
      setStoredValue(valueToStore);
      window.localStorage.setItem(key, JSON.stringify(valueToStore));
    } catch (error) {
      console.log(error);
    }
  }, [key, storedValue]);

  return [storedValue, setValue] as const;
}

// メモ化を活用した最適化
function ExpensiveComponent({ items }: { items: string[] }) {
  // 重い計算をメモ化
  const expensiveValue = useMemo(() => {
    return items.reduce((acc, item) => {
      // 何らかの重い処理
      return acc + item.length;
    }, 0);
  }, [items]);

  // コールバック関数をメモ化
  const handleClick = useCallback((item: string) => {
    console.log(`Clicked: ${item}`);
  }, []);

  return (
    <div>
      <p>Total length: {expensiveValue}</p>
      {items.map((item, index) => (
        <button key={index} onClick={() => handleClick(item)}>
          {item}
        </button>
      ))}
    </div>
  );
}
