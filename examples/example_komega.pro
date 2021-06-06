; pro example_komega

data_dir = 'sample_data/'

data = readfits(data_dir+'sdo_aia1700.fits', /silent)
cadence = 12. ; sec
arcsecpx = 0.6 ; arcsec

nt = n_elements(data[0,0,*])

time = findgen(nt)*cadence

colset
device, decomposed=0

; create an eps file of the k-omega diagram for frequency and wavenumber ranges of interest
WaLSAtools, /komega, signal=data, time=time, arcsecpx=arcsecpx, power=p, frequencies=f, wavenumber=k, $
            xrange=[1,4], yrange=[1,15], /smooth, eps='~/WaLSAtools_k-omega_1', koclt=1

; create an eps file of the k-omega diagram for frequency and wavenumber ranges of interest
WaLSAtools, /komega, signal=data, time=time, arcsecpx=arcsecpx, power=p, frequencies=f, wavenumber=k, $
            xrange=[0.2,3.1], yrange=[30,38], /smooth, eps='~/WaLSAtools_k-omega_2', koclt=1

; plot the k-omega diagram for the entire ranges and do filtering (interactively) in the wavenumber-frequency space
WaLSAtools, /komega, signal=data, cadence=cadence, arcsecpx=arcsecpx, power=p, frequencies=f, wavenumber=k, $
            /filtering, filtered_cube=filtered_cube

PRINT

end