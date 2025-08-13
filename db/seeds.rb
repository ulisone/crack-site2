# Software Crackz - Seed Data
# 카테고리 생성
categories = [
  { name: "Audio & Music", position: 1, description: "오디오 편집, 음악 제작 및 사운드 관련 소프트웨어" },
  { name: "Graphics & Design", position: 2, description: "그래픽 디자인, 이미지 편집 및 창작 도구" },
  { name: "Video Editing", position: 3, description: "동영상 편집, 영상 제작 및 미디어 처리 소프트웨어" },
  { name: "Office & Productivity", position: 4, description: "사무용 소프트웨어 및 생산성 도구" },
  { name: "Security & Privacy", position: 5, description: "보안, 프라이버시 및 시스템 보호 도구" },
  { name: "System Utilities", position: 6, description: "시스템 최적화, 유틸리티 및 관리 도구" },
  { name: "Games", position: 7, description: "게임 및 엔터테인먼트 소프트웨어" },
  { name: "Developer Tools", position: 8, description: "개발 도구, IDE 및 프로그래밍 소프트웨어" }
]

puts "Creating categories..."
categories.each do |cat_data|
  Category.find_or_create_by(name: cat_data[:name]) do |category|
    category.position = cat_data[:position]
    category.description = cat_data[:description]
  end
end

puts "Created #{Category.count} categories"

# 샘플 소프트웨어 생성 (개발용)
if Rails.env.development?
  puts "Creating sample software entries..."
  
  Category.find_each do |category|
    case category.name
    when "Audio & Music"
      softwares = [
        { title: "FL Studio Producer Edition", version: "21.2.0", developer: "Image-Line", description: "전문적인 음악 제작을 위한 완전한 소프트웨어 스튜디오. 고급 미디 시퀀싱, 오디오 편집, 믹싱 기능을 제공합니다." },
        { title: "Adobe Audition", version: "2024", developer: "Adobe Systems", description: "전문가급 오디오 워크스테이션으로 팟캐스트, 음악, 사운드 이펙트 제작에 최적화되어 있습니다." }
      ]
    when "Graphics & Design"
      softwares = [
        { title: "Adobe Photoshop", version: "2024", developer: "Adobe Systems", description: "업계 표준 이미지 편집 소프트웨어. 사진 편집, 그래픽 디자인, 디지털 아트 제작의 모든 기능을 제공합니다." },
        { title: "CorelDRAW Graphics Suite", version: "2024", developer: "Corel Corporation", description: "벡터 일러스트레이션, 레이아웃, 사진 편집을 위한 종합 그래픽 디자인 소프트웨어입니다." }
      ]
    when "Video Editing"
      softwares = [
        { title: "Adobe Premiere Pro", version: "2024", developer: "Adobe Systems", description: "전문가를 위한 동영상 편집 소프트웨어. 영화, TV, 웹용 콘텐츠 제작에 사용되는 업계 표준입니다." },
        { title: "Final Cut Pro", version: "10.7", developer: "Apple Inc.", description: "Mac 전용 프로페셔널 비디오 편집 소프트웨어. 혁신적인 편집 기능과 강력한 미디어 관리를 제공합니다." }
      ]
    when "Office & Productivity"
      softwares = [
        { title: "Microsoft Office Professional Plus", version: "2024", developer: "Microsoft Corporation", description: "Word, Excel, PowerPoint, Outlook 등을 포함한 완전한 오피스 생산성 제품군입니다." },
        { title: "Adobe Acrobat Pro DC", version: "2024", developer: "Adobe Systems", description: "PDF 문서 작성, 편집, 서명, 공유를 위한 완전한 솔루션입니다." }
      ]
    when "Security & Privacy"
      softwares = [
        { title: "Malwarebytes Premium", version: "5.0", developer: "Malwarebytes", description: "고급 맬웨어 탐지 및 제거, 실시간 보호 기능을 제공하는 보안 소프트웨어입니다." },
        { title: "ExpressVPN", version: "12.0", developer: "Express Technologies", description: "빠르고 안전한 VPN 서비스로 온라인 개인정보를 보호하고 지역 제한을 우회할 수 있습니다." }
      ]
    when "System Utilities"
      softwares = [
        { title: "CCleaner Professional", version: "6.20", developer: "Piriform", description: "시스템 정리, 레지스트리 최적화, 성능 향상을 위한 종합 시스템 유틸리티입니다." },
        { title: "IObit Advanced SystemCare", version: "17.0", developer: "IObit", description: "PC 최적화, 정리, 보안을 위한 올인원 시스템 관리 도구입니다." }
      ]
    when "Games"
      softwares = [
        { title: "Steam", version: "Latest", developer: "Valve Corporation", description: "PC 게임 플랫폼의 표준. 수천 개의 게임과 커뮤니티 기능을 제공합니다." },
        { title: "Epic Games Launcher", version: "Latest", developer: "Epic Games", description: "Fortnite, Unreal Engine 게임들과 매주 무료 게임을 제공하는 게임 런처입니다." }
      ]
    when "Developer Tools"
      softwares = [
        { title: "JetBrains IntelliJ IDEA Ultimate", version: "2024.1", developer: "JetBrains", description: "Java 및 다중 언어 개발을 위한 강력한 통합 개발 환경입니다." },
        { title: "Microsoft Visual Studio Professional", version: "2022", developer: "Microsoft Corporation", description: "Windows, 웹, 모바일 앱 개발을 위한 완전한 개발 도구입니다." }
      ]
    end
    
    softwares&.each do |soft_data|
      Software.find_or_create_by(title: soft_data[:title], category: category) do |software|
        software.version = soft_data[:version]
        software.developer = soft_data[:developer]
        software.description = soft_data[:description]
        software.published = true
        software.file_size = rand(50..500).megabytes
        software.os_requirements = "Windows 10/11, macOS 12+, Linux"
      end
    end
  end
  
  puts "Created #{Software.count} software entries"
  puts "Seed data creation completed!"
end
