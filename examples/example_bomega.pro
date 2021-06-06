; pro example_bomega

data_dir = 'sample_data/'

data = readfits(data_dir+'sdo_aia1700.fits', /silent)
bmap = readfits(data_dir+'sdo_hmimag.fits', /silent)

; limit the field to a region of interest
clip = [210,300,215,255]

data = data[clip[0]:clip[1],clip[2]:clip[3],*]

; LOS component of the magnetic field at the middle of the time series
bmap = bmap[clip[0]:clip[1],clip[2]:clip[3]]

cadence = 12. ; sec
arcsecpx = 0.6 ; arcsec

nt = n_elements(data[0,0,*])
time = findgen(nt)*cadence

; create an eps file of the B-omega diagram for frequency and wavenumber ranges of interest
WaLSAtools, /bomega, signal=data, time=time, bmap=bmap, power=p, frequencies=f, barray=b, $
            yrange=[1,20], /smooth, /threemin, /fivemin, eps='sample_data/b-omega', koclt=1, /ylog

PRINT

end