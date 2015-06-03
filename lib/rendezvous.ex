defmodule Rendezvous do
  import Enum
  use FitEx

  def get_node key do
    nodes = map [Node.self | Node.list], &to_string/1
    get(:sha, key, nodes)
  end

  def get algorithm, key, buckets do
    {bucket, _hash} = map(buckets, f get_bucket_with_hash(algorithm, it, key)) 
                      |> max_by fn {_b, hash} -> hash end
    bucket
  end

  defp get_bucket_with_hash(algorithm, bucket, key) do
    {bucket, compute_bucket_hash(algorithm, bucket, key)}
  end

  defp compute_bucket_hash(algorithm, bucket,key) do
    :crypto.hash(algorithm,[bucket,key] )
  end
end
