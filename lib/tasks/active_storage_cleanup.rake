namespace :active_storage do
  desc "Clean up Active Storage blobs without corresponding files"
  task cleanup_orphaned_blobs: :environment do
    puts "Starting Active Storage cleanup..."
    
    orphaned_count = 0
    total_blobs = ActiveStorage::Blob.count
    
    ActiveStorage::Blob.find_each do |blob|
      file_path = ActiveStorage::Blob.service.path_for(blob.key)
      
      unless File.exist?(file_path)
        puts "Orphaned blob found: #{blob.key} (#{blob.filename})"
        
        # Remove attachments first
        ActiveStorage::Attachment.where(blob: blob).destroy_all
        
        # Remove blob
        blob.destroy
        
        orphaned_count += 1
      end
    end
    
    puts "Cleanup completed: #{orphaned_count}/#{total_blobs} orphaned blobs removed"
  end
  
  desc "List all blobs and their file existence status"
  task audit_blobs: :environment do
    puts "Auditing Active Storage blobs..."
    
    ActiveStorage::Blob.find_each do |blob|
      file_path = ActiveStorage::Blob.service.path_for(blob.key)
      exists = File.exist?(file_path)
      status = exists ? "✅ EXISTS" : "❌ MISSING"
      
      puts "#{status} | #{blob.key} | #{blob.filename} | #{blob.content_type}"
    end
  end
  
  desc "Clean up orphaned variant records without image attachments"
  task cleanup_orphaned_variants: :environment do
    puts "Starting variant record cleanup..."
    
    orphaned_count = 0
    total_variants = ActiveStorage::VariantRecord.count
    
    ActiveStorage::VariantRecord.find_each do |variant|
      unless variant.image.attached?
        puts "Orphaned variant found: ID #{variant.id} (blob_id: #{variant.blob_id})"
        variant.destroy
        orphaned_count += 1
      end
    end
    
    puts "Variant cleanup completed: #{orphaned_count}/#{total_variants} orphaned variants removed"
  end
  
  desc "Comprehensive Active Storage cleanup"
  task cleanup_all: :environment do
    puts "Starting comprehensive Active Storage cleanup..."
    
    Rake::Task['active_storage:cleanup_orphaned_variants'].invoke
    Rake::Task['active_storage:cleanup_orphaned_blobs'].invoke
    
    puts "Comprehensive cleanup completed!"
  end
end