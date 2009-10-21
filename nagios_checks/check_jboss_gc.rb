gc_log=ARGV[0]
data=`tail -10 #{gc_log}`

start=0
end_time = 0
elapsed =0
full_gcs=[]
max=0
min=0
data.each_line do |l|
   parts=l.split(":")
   time=parts[0].to_f
   end_time = time
   if (start ==0) then 
     start = time
   end
   elapsed = time  - start 
   if (l =~ /Full GC/) then
      full_gcs.push(time)
   end
   if ((l=~/.*GC ([0-9]*)K->([0-9]*)K.*/) or 
      (l=~/.*ParNew ([0-9]*)K->([0-9]*)K.*/) ) then
     max = $1
     min = $2
   end
end
cutoff = end_time - 60
full_gc_count = 0
full_gcs.reverse_each do |gc_time|
  if ( gc_time > cutoff) then
    full_gc_count = full_gc_count + 1
  end
end
gc_rate = format("%.4f",10/(end_time - start)) 
if (full_gc_count > 3) then
   state="CRITICAL #{full_gc_count} Full GCs in last minute"
   exit_code=2
else
   state="OK"
   exit_code=0
end
puts "#{state}|full_last_min=#{full_gc_count};;;;gc_rate=#{gc_rate};;;;max_heap=#{max};;;;min_heap=#{min}"
exit exit_code

