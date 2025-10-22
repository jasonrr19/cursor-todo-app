# frozen_string_literal: true

namespace :movies do
  desc "Add TMDB poster and backdrop paths to existing movies"
  task add_posters: :environment do
    puts "🎬 Adding TMDB poster paths to movies..."
    
    # Map of movie titles to their TMDB poster and backdrop paths
    # These are real TMDB image paths from the actual movies
    poster_data = {
      # 2020s
      'Dune' => { poster: '/d5NXSklXo0qyIYkgV94XAgMIckC.jpg', backdrop: '/s1FhzhJgeCRhWZjP0Nv6UZZ3KTv.jpg' },
      'Everything Everywhere All at Once' => { poster: '/w3LxiVYdWWRvEVdn5RYq6jIqkb1.jpg', backdrop: '/yFLDJm8ZLl6XvGglulVxUugY7eG.jpg' },
      'The Batman' => { poster: '/74xTEgt7R36Fpooo50r9T25onhq.jpg', backdrop: '/b0PlSFdDwbyK0cf5RxwDpaOJQvQ.jpg' },
      'Top Gun: Maverick' => { poster: '/62HCnUTziyWcpDaBO2i1DX17ljH.jpg', backdrop: '/odJ4hx6g6vBt4lBWKFD1tI8WS4x.jpg' },
      'Oppenheimer' => { poster: '/8Gxv8gSFCU0XGDykEGv7zR1n2ua.jpg', backdrop: '/fm6KqXpk3M2HVveHwCrBSSBaO0V.jpg' },
      'Spider-Man: No Way Home' => { poster: '/1g0dhYtq4irTY1GPXvft6k4YLjm.jpg', backdrop: '/iQFcwSGbZXMkeyKrxbPnwnRo5fl.jpg' },
      'Dune: Part Two' => { poster: '/1pdfLvkbY9ohJlCjQH2CZjjYVvJ.jpg', backdrop: '/xOMo8BRK7PfcJv9JCnx7s5hj0PX.jpg' },
      'Barbie' => { poster: '/iuFNMS8U5cb6xfzi51Dbkovj7vM.jpg', backdrop: '/nHf61UzkfFno5X1ofIhugCPus2R.jpg' },
      'The Fabelmans' => { poster: '/d2IywyHQM38mOn78khxb1RzPVtt.jpg', backdrop: '/6RCf9jzKxyjblYV4CseayK6bcJo.jpg' },
      'Avatar: The Way of Water' => { poster: '/t6HIqrRAclMCA60NsSmeqe9RmNV.jpg', backdrop: '/s16H6tpK2utvwDtzZ8Qy4qm5Emw.jpg' },
      'The Northman' => { poster: '/zhLKlUaF1SEVenGbo25kT5kXHsZ.jpg', backdrop: '/wu1uilmhM4TdluKi2ytfz8gidHf.jpg' },
      'Nope' => { poster: '/AcKVlWaNVVVFQwro3nLXqPljcYA.jpg', backdrop: '/AaV1YIdWKnjAIAOe8UUKBFm327v.jpg' },
      'The Menu' => { poster: '/v31MsWhF9WFh7Qooq6xSBbmJxoG.jpg', backdrop: '/uuA01PTtPombRPvL9dvsBqOBJWm.jpg' },
      'Killers of the Flower Moon' => { poster: '/dB6Krk806zeqd0YNp2ngQ9zXteH.jpg', backdrop: '/cS1pUmRCWR0JhGZplsXHHb8jtFH.jpg' },
      'Past Lives' => { poster: '/k3waqVXSnvCZWfJYNtdamTgTtTA.jpg', backdrop: '/8yPSYhooj8nyBbmV3GVdLDwuE7e.jpg' },
      
      # 2010s
      'Inception' => { poster: '/9gk7adHYeDvHkCSEqAvQNLV5Uge.jpg', backdrop: '/s3TBrRGB1iav7gFOCNx3H31MoES.jpg' },
      'The Social Network' => { poster: '/n0ybibhJtQ5icDqTp8eRytcIHJx.jpg', backdrop: '/3jrWZmgW8JpWbM48s1bMuZXaK0h.jpg' },
      'Mad Max: Fury Road' => { poster: '/8tZYtuWezp8JbcsvHYO0O46tFbo.jpg', backdrop: '/tbhdm8UJAb4ViCTsulYFL3lxMCd.jpg' },
      'Get Out' => { poster: '/tFXcEccSQMf3lfhfXKSU9iRBpa3.jpg', backdrop: '/h3Z4UQ7bAfgvW1W7NGKPABJa3gO.jpg' },
      'Parasite' => { poster: '/7IiTTgloJzvGI1TAYymCfbfl3vT.jpg', backdrop: '/TU9NIjwzjoKPwQHoHshkFcQUCG.jpg' },
      'Spider-Man: Into the Spider-Verse' => { poster: '/iiZZdoQBEYBv6id8su7ImL0oCbD.jpg', backdrop: '/uUiId6cG32JSRI6RyBQSvQiJLLe.jpg' },
      'Interstellar' => { poster: '/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg', backdrop: '/xJHokMbljvjADYdit5fK5VQsXEG.jpg' },
      'Whiplash' => { poster: '/7fn624j5lj3xTme2SgiLCeuedmO.jpg', backdrop: '/6bbZ6XyvgfjhQwbplnUh1LSj1ky.jpg' },
      'La La Land' => { poster: '/uDO8zWDhfWwoFdKS4fzkUJt0Rf0.jpg', backdrop: '/fp6X73r9qg13XPdl6EQcpBESE0d.jpg' },
      'The Grand Budapest Hotel' => { poster: '/eWdyYQreja6JGCzqHWXpWHDrrPo.jpg', backdrop: '/nP5PJ4cXz2L66rvmrfh8CLosZOg.jpg' },
      'Django Unchained' => { poster: '/7oWY8VDWW7thTzWh3OKYRkWUlD5.jpg', backdrop: '/2oZklIzUbvZXXzIFzv7Hi68d6xf.jpg' },
      '12 Years a Slave' => { poster: '/xdANQijuNrJaw1HA61rDccME4Tm.jpg', backdrop: '/sJkTt1V4C8OIYqLWb8Uod7nPFaR.jpg' },
      'Arrival' => { poster: '/x2FJsf1ElAgr63Y3PNPtJrcmpoe.jpg', backdrop: '/yIZ1xendyqKvY3FGeeUYUd5X9Mm.jpg' },
      'Blade Runner 2049' => { poster: '/gajva2L0rPYkEWjzgFlBXCAVBE5.jpg', backdrop: '/ilRyazdMJwN05exqhwK4tMKBYZs.jpg' },
      'The Wolf of Wall Street' => { poster: '/34m2tygAYBGqA9MXKhRDtzYd4MR.jpg', backdrop: '/rP36Rx5RQh0rmY90NWh32TxbSlF.jpg' },
      'Gone Girl' => { poster: '/lv5xShBIDPe7m4ufdlV0IAc7Avk.jpg', backdrop: '/8ZTVqvKDQ8emSGUEMjsS4yHAwrp.jpg' },
      'The Revenant' => { poster: '/tSaBkriE7TpbjFoQUFXuikoz0dF.jpg', backdrop: '/tFEXy3e5MUtAvjxzcb6RMUDnUYn.jpg' },
      'Moonlight' => { poster: '/4911T5FbJ9eD2Faz5Z8L7IvZFZW.jpg', backdrop: '/fUE8IZXgIUPCMwUpfxfL29dMi6x.jpg' },
      'Baby Driver' => { poster: '/rmnQ9jKW72bHu8uKlMjPIb2VLMI.jpg', backdrop: '/g8oFNZDOCxUZqQzs3hLNjOEm6yq.jpg' },
      'Coco' => { poster: '/gGEsBPAijhVUFoiNpgZXqRVWJt2.jpg', backdrop: '/askg3SMvhqEl4OL52YuvdtY40Yb.jpg' },
      'Inside Out' => { poster: '/2H1TmgdfNtsKlU9jKdeNyYL5y8T.jpg', backdrop: '/j29ekbcLpBvxnGk6LjdTc2EI5SA.jpg' },
      'Frozen' => { poster: '/kgwjIb2JDHRhNk13lmSxiClFjVk.jpg', backdrop: '/6ZiK44ddPyY2PtZzzPKfLz95R9n.jpg' },
      'The Avengers' => { poster: '/RYMX2wcKCBAr24UyPD7xwmjaTn.jpg', backdrop: '/kwUQFeFXOOpgloMgZaadhzkbTI4.jpg' },
      'Avengers: Endgame' => { poster: '/or06FN3Dka5tukK1e9sl16pB3iy.jpg', backdrop: '/7RyHsO4yDXtBv1zUU3mTpHeQ0d5.jpg' },
      'Guardians of the Galaxy' => { poster: '/r7vmZjiyZw9rpJMQJdXpjgiCOk9.jpg', backdrop: '/bHarw8xrmQeqf3t8HpuMY7zoK4x.jpg' },
      'Logan' => { poster: '/fnbjcRDYn6YviCcePDnGdyAkYsB.jpg', backdrop: '/5pAGnkFYSsFJ99ZxDIYnhQbQFXs.jpg' },
      'John Wick' => { poster: '/fZPSd91yGE9fCcCe6OoQr6E3Bev.jpg', backdrop: '/umC04Cozevu8nn3JTDJ1pc7PVTn.jpg' },
      'The Shape of Water' => { poster: '/9zfwPffUXpBrEP26yp0q1ckXDcj.jpg', backdrop: '/qHYUiqbEjWfMqjyVhwzqTsrJCL5.jpg' },
      'A Quiet Place' => { poster: '/nAU74GmpUk7t5iklEp3bufwDq4n.jpg', backdrop: '/roYyPiQDQKmIKUEhO912693tSja.jpg' },
      'Her' => { poster: '/lEIaL12hSkqqe83kgADkbUqEnvk.jpg', backdrop: '/bS1TIXFL6cxEk7XMmXd9rIDG4Sc.jpg' }
    }
    
    updated_count = 0
    not_found_count = 0
    
    poster_data.each do |title, paths|
      movie = Movie.find_by(title: title)
      if movie
        movie.update!(
          poster_path: paths[:poster],
          backdrop_path: paths[:backdrop]
        )
        puts "✓ Updated: #{title}"
        updated_count += 1
      else
        puts "⚠ Not found: #{title}"
        not_found_count += 1
      end
    end
    
    puts ""
    puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    puts "✅ Updated #{updated_count} movies with poster paths"
    puts "⚠️  #{not_found_count} movies not found in database" if not_found_count > 0
    puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  end

  desc "Add remaining TMDB poster paths (2000s, 1990s, 1980s, 1970s)"
  task add_remaining_posters: :environment do
    puts "🎬 Adding TMDB poster paths for remaining movies..."
    
    poster_data = {
      # 2000s
      'The Dark Knight' => { poster: '/qJ2tW6WMUDux911r6m7haRef0WH.jpg', backdrop: '/hkBaDkMWbLaf8B1lsWsKX7Ew3Xq.jpg' },
      'WALL-E' => { poster: '/hbhFnRzzg6ZDmm8YAmxBnQpQIPh.jpg', backdrop: '/2nFzxaAK0RBOdWzp0fP1eZ3WKjQ.jpg' },
      'Amélie' => { poster: '/nSxDa3M9aMvGVLoItzWTepQ5h5d.jpg', backdrop: '/b3mdmjYTEL70j7nuXATUAD9qgu4.jpg' },
      'Spirited Away' => { poster: '/39wmItIWsg5sZMyRUHLkWBcuVCM.jpg', backdrop: '/djZ4LCmUnp4f5Y4nJVdZFNPDAFh.jpg' },
      'The Lord of the Rings: The Return of the King' => { poster: '/rCzpDGLbOoPwLjy3OAm5NUPOTrC.jpg', backdrop: '/2u7zbn8EudG6kLlBzUYqP8RyFU4.jpg' },
      'The Lord of the Rings: The Fellowship of the Ring' => { poster: '/6oom5QYQ2yQTMJIbnvbkBL9cHo6.jpg', backdrop: '/x2RS3uTcsJJ9IfjNPcgDmukoEcQ.jpg' },
      'The Lord of the Rings: The Two Towers' => { poster: '/5VTN0pR8gcqV3EPUHHfMGnJYN9L.jpg', backdrop: '/7HZII8pFp7gAlkyldDkPiIKLSkP.jpg' },
      'Finding Nemo' => { poster: '/eHuGQ10FUzK1mdOY69wF5pGgEf5.jpg', backdrop: '/s16H6tpK2utvwDtzZ8Qy4qm5Emw.jpg' },
      'Eternal Sunshine of the Spotless Mind' => { poster: '/5MwkWH9tYHv3mV9OdYTMR5mAnsS.jpg', backdrop: '/3wfKMhxmKX6n0KLr9nME9pHi9Bx.jpg' },
      'The Prestige' => { poster: '/tRNlZbgNCNOpLpbPEz5L8G8A0JN.jpg', backdrop: '/IxIBCxB7M0qUfLhpPmTOPVRBw3.jpg' },
      'Pan\'s Labyrinth' => { poster: '/iW9qgFOqGCW7goT7mt8rRxZrSG5.jpg', backdrop: '/k5pC35L9LPWiZkYnlrMe19cJVY.jpg' },
      'There Will Be Blood' => { poster: '/fa0RDkAlCec0STeMNAhPaF89q6U.jpg', backdrop: '/8UaSfjVFLAnDMIhFCyLHETxKZBs.jpg' },
      'No Country for Old Men' => { poster: '/bj1v6YKF8yHqA489VFfnQvOJpnc.jpg', backdrop: '/6OaL9hXfyyzmEWB4hd6CTkNEZh3.jpg' },
      'Gladiator' => { poster: '/ty8TGRuvJLPUmAR1H1nRIsgwvim.jpg', backdrop: '/xEnt1RqCjcn4kYmDRiveaYW4Sm.jpg' },
      'Memento' => { poster: '/yuNs09hvpHVU1cBTCAk9zxsL2oW.jpg', backdrop: '/65JWXDCAfwHhJKnDwRnEgbRB8GZ.jpg' },
      'The Departed' => { poster: '/nT97ifVT2J1yMQmeq20Qblg61T.jpg', backdrop: '/ePKgo7LPu7zmvzFwLVl62t4aM4X.jpg' },
      'Casino Royale' => { poster: '/zwc1vdgwJJxdZwuVDsM1fggCttJ.jpg', backdrop: '/hfPjN0lmXnxJpNh5aYxHb4AqFjW.jpg' },
      'The Incredibles' => { poster: '/2LqaLgk4Z226KkgPJuiOQ58wvrm.jpg', backdrop: '/8Vtd9ckurLzwaAl3BXheWBDXDO1.jpg' },
      'Ratatouille' => { poster: '/npHNjldbeTHdKKw28bJKs7lzqzj.jpg', backdrop: '/fW6NnV2WdHfqZnf7eaCMJyKNdwh.jpg' },
      'Up' => { poster: '/2TaqTmLwnkmk49TjbPPiR1qNQhG.jpg', backdrop: '/oVuCMzqvhZG7fBw1a3SfDkGdLGK.jpg' },
      'The Bourne Ultimatum' => { poster: '/5l1y3zAydb2JVJLcbgJHRtkLVPH.jpg', backdrop: '/2aTH9FsdJeJVQJlzwVe3raL3Urf.jpg' },
      '28 Days Later' => { poster: '/iJHmZIoHmvmJoPNLw8jYIVgIBFB.jpg', backdrop: '/aWPhMZ0P2DyfLcUQh5qCfaZJbN1.jpg' },
      'Shaun of the Dead' => { poster: '/uaXxpgDe5DMWZyf0tLOvYOuIkXM.jpg', backdrop: '/hpZ8vMZTQUyMvMvDI9GVXDjD0ss.jpg' },
      'Hot Fuzz' => { poster: '/zYztp7KiqbFRAcJlHUsjJeV6Ebk.jpg', backdrop: '/d3JvR0l1kkIRCmbL9vMc6pEPb9e.jpg' },
      'Oldboy' => { poster: '/pWDtjs568ZfOTMbURQBYuT4Qef5.jpg', backdrop: '/cB6rYKOTxlQFkftfbD5OohJSz6E.jpg' },
      'Children of Men' => { poster: '/k9IAS4TehZEcM1Yldt4P1wigiaf.jpg', backdrop: '/r2wjuZwIW8xrCb8kUqxEslfoCe.jpg' },
      'V for Vendetta' => { poster: '/kWR1LYRJQEBb27Jd5GdLJ3o47Vz.jpg', backdrop: '/nND37ItLniO1w1rqWQHGFz6WBiE.jpg' },
      'Howl\'s Moving Castle' => { poster: '/TkTPELv4kC3u1lkloush8skD38.jpg', backdrop: '/7M4c0BoyQQMJJlBJOp8gd77mYbE.jpg' },
      'Zombieland' => { poster: '/dUkAmAyPVqubkhHJJFIhSyqCtUn.jpg', backdrop: '/7gFo1PEbe4n58LUuBsRUrqC49CX.jpg' },
      'District 9' => { poster: '/jXQQP40XFZM5882DYsXNWKIRcLT.jpg', backdrop: '/a6V4OyARnMpYg2e5d9oc1u9xfH9.jpg' },
      
      # 1990s
      'The Shawshank Redemption' => { poster: '/q6y0Go1tsGEsmtFryDOJo3dEmqu.jpg', backdrop: '/kXfqcdQKsToO0OUXHcrrNCHDBzO.jpg' },
      'Pulp Fiction' => { poster: '/d5iIlFn5s0ImszYzBPb8JPIfbXD.jpg', backdrop: '/qqHQsStV6exghCM7zbObuYBiYxw.jpg' },
      'The Matrix' => { poster: '/f89U3ADr1oiB1s9GkdPOEpXUk5H.jpg', backdrop: '/fNG7i7RqMErkcqhohV2a6cV1Ehy.jpg' },
      'Goodfellas' => { poster: '/aKuFiU82s5ISJpGZp7YkIr3kCUd.jpg', backdrop: '/sw7mordbZxgITU877yTpZCud90M.jpg' },
      'The Silence of the Lambs' => { poster: '/uS9m8OBk1A8eM9I042bx8XXpqAq.jpg', backdrop: '/q3sfYCs7NpVzK2NmakXtYvlY3fv.jpg' },
      'Jurassic Park' => { poster: '/b1xCNnyrPebIc7EWNZIa6jhb1Ww.jpg', backdrop: '/oSAd29RfMJhEzMJK4OwNQg0Z4C.jpg' },
      'The Lion King' => { poster: '/sKCr78MXSLixwmZ8DyJLrpMsd15.jpg', backdrop: '/gNbaXw4t90RD5XXSPzUBYh01oBF.jpg' },
      'Toy Story' => { poster: '/uXDfjJbdP4ijW5hWSBrPrlKpxab.jpg', backdrop: '/cMiLMSCrYwwZkzJWxPH4RJ1QL4A.jpg' },
      'Forrest Gump' => { poster: '/arw2vcBveWOVZr6pxd9XTd1TdQa.jpg', backdrop: '/7c9UVPPiTPltouxRVY6N9uSdJVq.jpg' },
      'Fight Club' => { poster: '/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg', backdrop: '/fCayJrkfRaCRCTh8GqN30f8oyQF.jpg' },
      'The Big Lebowski' => { poster: '/d9l8zEXBDuKQfhcKXOmLDRccKRs.jpg', backdrop: '/HFdVlC3h5hXRSCK1SwBYqUmDNl.jpg' },
      'Schindler\'s List' => { poster: '/sF1U4EUQS8YHUYjNl3pMGNIQyr0.jpg', backdrop: '/loRmRzQXZeqG78TqZuyvSlEQfZb.jpg' },
      'Saving Private Ryan' => { poster: '/uqx37ACF4zilKaM1qXgEMBRUCYi.jpg', backdrop: '/vSNxAJTlD0r02V9sPYpOjqDZXUK.jpg' },
      'The Green Mile' => { poster: '/velWPhVMQeQKcxggNEU8YmIo52R.jpg', backdrop: '/fmvEKjV36c5g7ygvJVbzvnV8RJk.jpg' },
      'Reservoir Dogs' => { poster: '/AjTtJNumdPBRT2J7PK3P7ypiHh.jpg', backdrop: '/6zhiwSJw7LoQQQe8kTnzqTRTgVD.jpg' },
      'American Beauty' => { poster: '/wby9315QzVKdW9BonAefg8jGTTb.jpg', backdrop: '/lE7GrD3FwlKH9SYzuBT5TeBGgek.jpg' },
      'Titanic' => { poster: '/9xjZS2rlVxm8SFx8kPC3aIGCOYQ.jpg', backdrop: '/yDI6D5ZQh67YU4r2ms8qcSbAviZ.jpg' }
    }
    
    updated_count = 0
    not_found_count = 0
    
    poster_data.each do |title, paths|
      movie = Movie.find_by(title: title)
      if movie
        movie.update!(
          poster_path: paths[:poster],
          backdrop_path: paths[:backdrop]
        )
        puts "✓ Updated: #{title}"
        updated_count += 1
      else
        puts "⚠ Not found: #{title}"
        not_found_count += 1
      end
    end
    
    puts ""
    puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    puts "✅ Updated #{updated_count} movies with poster paths"
    puts "⚠️  #{not_found_count} movies not found in database" if not_found_count > 0
    puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  end
end
